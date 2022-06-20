# C MEX: called from Matlab

find_file(MEX_C_SRC
NAMES matrixMultiply.c
NO_DEFAULT_PATH
PATHS ${Matlab_ROOT_DIR}/extern/examples/refbook
)

find_library(MEX_BLAS
NAMES libmwblas mwblas
NO_DEFAULT_PATH
PATHS ${Matlab_EXTERN_LIBRARY_DIR} ${Matlab_BINARIES_DIR}
PATH_SUFFIXES microsoft mingw64
)

if(MEX_C_SRC AND MEX_BLAS)
  # add_custom_target(matrixMultiply ALL
  # COMMAND ${Matlab_MEX_COMPILER} ${MEX_C_SRC} ${CMAKE_LIBRARY_PATH_FLAG}${Matlab_EXTERN_LIBRARY_DIR} ${MEX_BLAS}
  # BYPRODUCTS matrixMultiply.${Matlab_MEX_SUFFIX}
  # )

  matlab_add_mex(NAME matrixMultiply SHARED SRC ${MEX_C_SRC} LINK_TO ${MEX_BLAS})

  add_test(NAME BLAS
  COMMAND ${Matlab_MAIN_PROGRAM} -batch "addpath('${CMAKE_CURRENT_BINARY_DIR}'), r=runtests('${CMAKE_CURRENT_SOURCE_DIR}', 'Name', 'TestBlas/test_blas'); assertSuccess(r)"
  )
  # WORKING_DIRECTORY does not work, need addpath()
else()
  message(STATUS "SKIP: did not find ${MEX_C_SRC} and ${MEX_BLAS}")
endif()

get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)
set_tests_properties(${test_names} PROPERTIES TIMEOUT 90)

matlab_libpath("${test_names}")
