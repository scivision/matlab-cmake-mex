# https://www.mathworks.com/support/requirements/supported-compilers.html

set(matlab_timeout 90)

find_package(Matlab COMPONENTS MAIN_PROGRAM ENG_LIBRARY MX_LIBRARY MEX_COMPILER)

add_test(NAME Matlab:script
COMMAND ${Matlab_MAIN_PROGRAM} -batch "r=runtests('${CMAKE_CURRENT_SOURCE_DIR}', 'Name', 'TestDemo/test_true'); assertSuccess(r)")
set_tests_properties(Matlab:script PROPERTIES
TIMEOUT ${matlab_timeout}
DISABLED $<NOT:$<BOOL:${Matlab_FOUND}>>
)


include(matlab_include.cmake)

# --- C++ MEX
if(Matlab_ENG_LIBRARY_FOUND AND Matlab_MX_LIBRARY_FOUND)

find_file(MEX_C_SRC
NAMES matrixMultiply.c
NO_DEFAULT_PATH
HINTS ${Matlab_ROOT_DIR}/extern/examples/refbook
)

cmake_path(GET Matlab_MEX_LIBRARY PARENT_PATH Matlab_LIBRARY_DIR)

# find_library(MEX_BLAS
# NAMES mwblas
# NO_DEFAULT_PATH
# HINTS ${Matlab_LIBRARY_DIR}
# )

if(MEX_C_SRC AND Matlab_MEX_COMPILER)

add_custom_target(matmult_mex
COMMAND ${Matlab_MEX_COMPILER} -L${Matlab_LIBRARY_DIR} -lmwblas ${MEX_C_SRC}
BYPRODUCTS matrixMultiply${mexext}
)

add_test(NAME Matlab:BLAS
COMMAND ${Matlab_MAIN_PROGRAM} -batch "addpath('${CMAKE_CURRENT_BINARY_DIR}'), r=runtests('${CMAKE_CURRENT_SOURCE_DIR}', 'Name', 'TestDemo/test_blas'); assertSuccess(r)"
)
# WORKING_DIRECTORY does not work, need addpath()
set_tests_properties(Matlab:BLAS PROPERTIES
TIMEOUT ${matlab_timeout}
)

endif()

endif()


# --- Fortran MEX

if(WIN32 OR APPLE)
  if(NOT CMAKE_Fortran_COMPILER_ID MATCHES Intel)
    message(STATUS "SKIP: on Windows and MacOS, Matlab Fortran supports only Intel compiler.")
    return()
  endif()
else()
  if(NOT CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
    message(STATUS "SKIP: On Linux, Matlab Fortran supports only Gfortran.")
    return()
  endif()
endif()

if(Matlab_ENG_LIBRARY_FOUND AND Matlab_MX_LIBRARY_FOUND)
  add_executable(fengdemo fengdemo.F90)
  target_include_directories(fengdemo PRIVATE ${Matlab_INCLUDE_DIRS})
  target_link_libraries(fengdemo PRIVATE ${Matlab_LIBRARIES})

  add_test(NAME Matlab:Fortran COMMAND $<TARGET_FILE:fengdemo>)
  set_tests_properties(Matlab:Fortran PROPERTIES
    TIMEOUT ${matlab_timeout}
    ENVIRONMENT "${libenv}"
  )
endif()
