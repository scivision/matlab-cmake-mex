# https://www.mathworks.com/help/matlab/matlab_external/table-of-mex-file-source-code-files.html

set_property(DIRECTORY PROPERTY LABELS mex)
# C MEX: called from Matlab

find_file(matmul_src
NAMES matrixMultiply.c
NO_DEFAULT_PATH
PATHS ${Matlab_ROOT_DIR}/extern/examples/refbook
)

if(matmul_src AND Matlab_MEX_BLAS AND Matlab_mex_C)
  # add_custom_target(matrixMultiply ALL
  # COMMAND ${Matlab_MEX_COMPILER} ${matmul_src} ${CMAKE_LIBRARY_PATH_FLAG}${Matlab_EXTERN_LIBRARY_DIR} ${Matlab_MEX_BLAS}
  # )

matlab_add_mex(NAME matrixMultiply SHARED SRC ${matmul_src} LINK_TO ${Matlab_MEX_BLAS})

file(GENERATE OUTPUT CmexBatch.m CONTENT
"r=runtests('${CMAKE_CURRENT_SOURCE_DIR}', Name='TestMex/test_blas');

if sum(r.Incomplete) > 0
  fprintf(2, 'WARNING: Some tests were skipped.\\n')
  exit(77)
end

assert(~isempty(r), 'No tests were run.')

assertSuccess(r)
"
)

add_test(NAME C_MEX_BLAS
COMMAND ${Matlab_MAIN_PROGRAM} -batch "addpath('${CMAKE_CURRENT_BINARY_DIR}','$<TARGET_FILE_DIR:matrixMultiply>'), CmexBatch"
)

endif()

# --- C++ Mex called from Matlab

find_file(array_src
NAMES arrayProduct.cpp
NO_DEFAULT_PATH
PATHS ${Matlab_ROOT_DIR}/extern/examples/cpp_mex
)

if(array_src AND Matlab_mex_CXX)

message(STATUS "C++ mex source file: ${array_src}")

matlab_add_mex(NAME arrayProduct SHARED SRC ${array_src})

file(GENERATE OUTPUT CXXmexBatch.m CONTENT
"r=runtests('${CMAKE_CURRENT_SOURCE_DIR}', Name='TestMex/test_cpp_array');

if sum(r.Incomplete) > 0
  fprintf(2, 'WARNING: Some tests were skipped.\\n')
  exit(77)
end

assert(~isempty(r), 'No tests were run.')

assertSuccess(r)
"
)

add_test(NAME CXX_MEX_Array
COMMAND ${Matlab_MAIN_PROGRAM} -batch "addpath('${CMAKE_CURRENT_BINARY_DIR}','$<TARGET_FILE_DIR:arrayProduct>'), CXXmexBatch"
)

endif()

# --- Fortran Mex called from Matlab

find_file(matsq_src
NAMES matsq.F
NO_DEFAULT_PATH
PATHS ${Matlab_ROOT_DIR}/extern/examples/refbook
)

if(matsq_src AND Matlab_mex_Fortran)

message(STATUS "Fortran mex source file: ${matsq_src}")

matlab_add_mex(NAME matsq SHARED SRC ${matsq_src})

file(GENERATE OUTPUT FortranMexBatch.m CONTENT
"r=runtests('${CMAKE_CURRENT_SOURCE_DIR}', Name='TestMex/test_fortran_mex');

if sum(r.Incomplete) > 0
  fprintf(2, 'WARNING: Some tests were skipped.\\n')
  exit(77)
end

assert(~isempty(r), 'No tests were run.')

assertSuccess(r)
"
)

add_test(NAME FortranMex
COMMAND ${Matlab_MAIN_PROGRAM} -batch "addpath('${CMAKE_CURRENT_BINARY_DIR}','$<TARGET_FILE_DIR:matsq>'), FortranMexBatch"
)

endif()


# --- properties
get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)

matlab_libpath("${test_names}")

set_property(TEST ${test_names} PROPERTY SKIP_RETURN_CODE 77)
