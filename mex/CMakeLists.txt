# https://www.mathworks.com/help/matlab/matlab_external/table-of-mex-file-source-code-files.html

set_property(DIRECTORY PROPERTY LABELS mex)
# C MEX: called from Matlab

find_file(BLAS_SRC
NAMES matrixMultiply.c
NO_DEFAULT_PATH
PATHS ${Matlab_ROOT_DIR}/extern/examples/refbook
)

set(matsuf)
if(MSVC)
  set(matsuf microsoft)
elseif(MINGW)
  set(matsuf mingw64)
endif()

find_library(MEX_BLAS
NAMES libmwblas mwblas
NO_DEFAULT_PATH
PATHS ${Matlab_EXTERN_LIBRARY_DIR} ${Matlab_BINARIES_DIR}
PATH_SUFFIXES ${matsuf}
)

if(BLAS_SRC AND MEX_BLAS)
  # add_custom_target(matrixMultiply ALL
  # COMMAND ${Matlab_MEX_COMPILER} ${BLAS_SRC} ${CMAKE_LIBRARY_PATH_FLAG}${Matlab_EXTERN_LIBRARY_DIR} ${MEX_BLAS}
  # BYPRODUCTS matrixMultiply.${Matlab_MEX_SUFFIX}
  # )

  matlab_add_mex(NAME matrixMultiply SHARED SRC ${BLAS_SRC} LINK_TO ${MEX_BLAS})
  set_property(TARGET matrixMultiply PROPERTY RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

  add_test(NAME BLAS
  COMMAND ${Matlab_MAIN_PROGRAM} -batch "r=runtests('${CMAKE_CURRENT_SOURCE_DIR}', Name='TestMex/test_blas'); assertSuccess(r)"
  )
else()
  message(STATUS "SKIP: did not find matrixMultiply.c and libmwblas")
endif()

# --- C++ Mex called from Matlab

find_file(array_src
NAMES arrayProduct.cpp
NO_DEFAULT_PATH
PATHS ${Matlab_ROOT_DIR}/extern/examples/cpp_mex
)

if(array_src)
  matlab_add_mex(NAME arrayProduct SHARED SRC ${array_src})
  set_property(TARGET arrayProduct PROPERTY RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

  add_test(NAME CppArray
  COMMAND ${Matlab_MAIN_PROGRAM} -batch "r=runtests('${CMAKE_CURRENT_SOURCE_DIR}', Name='TestMex/test_cpp_array'); assertSuccess(r)"
  )
else()
  message(STATUS "SKIP:MEX: did not find arrayProduct.cpp")
endif()

# --- Fortran Mex called from Matlab

find_file(matsq_src
NAMES matsq.F
NO_DEFAULT_PATH
PATHS ${Matlab_ROOT_DIR}/extern/examples/refbook
)

if(matsq_src AND Matlab_engine_Fortran)

  # matlab_add_mex(NAME matsq SHARED SRC ${matsq_src})

  # add_custom_target(matsq ALL
  # COMMAND ${Matlab_MEX_COMPILER} ${matsq_src} ${CMAKE_LIBRARY_PATH_FLAG}${Matlab_EXTERN_LIBRARY_DIR}
  # BYPRODUCTS matsq.${Matlab_MEX_SUFFIX}
  # )

  # set_property(TARGET matsq PROPERTY RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

  # add_test(NAME FortranMex
  # COMMAND ${Matlab_MAIN_PROGRAM} -batch "r=runtests('${CMAKE_CURRENT_SOURCE_DIR}', Name='TestMex/test_fortran_mex'); assertSuccess(r)"
  # )

endif()


# --- properties
get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)
set_property(TEST ${test_names} PROPERTY TIMEOUT 90)

matlab_libpath("${test_names}")
