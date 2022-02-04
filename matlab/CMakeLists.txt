# https://www.mathworks.com/support/requirements/supported-compilers.html

set_directory_properties(PROPERTIES LABELS matlab)

set(matlab_timeout 90)

find_package(Matlab COMPONENTS MAIN_PROGRAM ENG_LIBRARY MX_LIBRARY MEX_COMPILER)
if(NOT Matlab_FOUND)
  return()
endif()

add_test(NAME Matlab_script
COMMAND ${Matlab_MAIN_PROGRAM} -batch "r=runtests('${CMAKE_CURRENT_SOURCE_DIR}', 'Name', 'TestDemo/test_true'); assertSuccess(r)")
set_tests_properties(Matlab_script PROPERTIES
TIMEOUT ${matlab_timeout}
DISABLED $<NOT:$<BOOL:${Matlab_FOUND}>>
)

if(NOT (Matlab_ENG_LIBRARY_FOUND AND Matlab_MX_LIBRARY_FOUND AND Matlab_MEX_COMPILER))
  return()
endif()

matlab_get_mex_suffix(${Matlab_ROOT_DIR} Matlab_MEX_SUFFIX)

cmake_path(GET Matlab_MEX_COMPILER PARENT_PATH Matlab_BINARY_DIR)

# --- C++ MEX: called from Matlab

find_file(MEX_C_SRC
NAMES matrixMultiply.c
NO_DEFAULT_PATH
HINTS ${Matlab_ROOT_DIR}/extern/examples/refbook
)

if(MEX_C_SRC)
  add_custom_target(matmult_mex ALL
  COMMAND ${Matlab_MEX_COMPILER} ${CMAKE_LIBRARY_PATH_FLAG}${Matlab_BINARY_DIR} -lmwblas ${MEX_C_SRC}
  BYPRODUCTS matrixMultiply${Matlab_MEX_SUFFIX}
  )

  # does not work since can't use link flags
  # matlab_add_mex(NAME matrixMultiply SHARED SRC ${MEX_C_SRC} LINK_TO -lmwblas R2018a)

  add_test(NAME Matlab:BLAS
  COMMAND ${Matlab_MAIN_PROGRAM} -batch "addpath('${CMAKE_CURRENT_BINARY_DIR}'), r=runtests('${CMAKE_CURRENT_SOURCE_DIR}', 'Name', 'TestDemo/test_blas'); assertSuccess(r)"
  )
  # WORKING_DIRECTORY does not work, need addpath()
  set_tests_properties(Matlab:BLAS PROPERTIES
  TIMEOUT ${matlab_timeout}
  )
endif()

# --- C calling Matlab Engine
if(CMAKE_VERSION VERSION_LESS 3.22)
  message(STATUS "SKIP: MatlabEngine tests require CMake >= 3.22")
  return()
endif()

add_executable(fengdemo_c fengdemo.c)
target_include_directories(fengdemo_c PRIVATE ${Matlab_INCLUDE_DIRS})
target_link_libraries(fengdemo_c PRIVATE ${Matlab_LIBRARIES})

add_test(NAME MatlabEngine_C COMMAND fengdemo_c)
set_tests_properties(MatlabEngine_C PROPERTIES TIMEOUT ${matlab_timeout})


# --- Fortran calling Matlab Engine

set(TestFortranEngine true)
if(WIN32 OR APPLE)
  if(NOT CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")
    message(STATUS "SKIP: on Windows and MacOS, Matlab Fortran supports only Intel compiler.")
    set(TestFortranEngine false)
  endif()
elseif(NOT CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  message(STATUS "SKIP: On Linux, Matlab Fortran supports only Gfortran.")
  set(TestFortranEngine false)
endif()



if(TestFortranEngine)
  add_executable(fengdemo_f fengdemo.F90)
  target_include_directories(fengdemo_f PRIVATE ${Matlab_INCLUDE_DIRS})
  target_link_libraries(fengdemo_f PRIVATE ${Matlab_LIBRARIES})

  add_test(NAME MatlabEngine_Fortran COMMAND fengdemo_f)
  set_tests_properties(MatlabEngine_Fortran PROPERTIES TIMEOUT ${matlab_timeout})
endif()

# --- Engine test props

foreach(t MatlabEngine_C MatlabEngine_Fortran)

if(NOT TEST ${t})
  continue()
endif()

if(APPLE)
  set_tests_properties(${t} PROPERTIES
  ENVIRONMENT_MODIFICATION DYLD_LIBRARY_PATH=path_list_prepend:${Matlab_BINARY_DIR}:${Matlab_ROOT_DIR}/sys/os/maci64
  )
elseif(WIN32)
  set_tests_properties(${t} PROPERTIES
  ENVIRONMENT_MODIFICATION PATH=path_list_prepend:${Matlab_BINARY_DIR}
  )
else()
  set_tests_properties(${t} PROPERTIES
  ENVIRONMENT_MODIFICATION LD_LIBRARY_PATH=path_list_prepend:${Matlab_BINARY_DIR}:${Matlab_ROOT_DIR}/sys/os/glnxa64
  )
endif()

endforeach()
