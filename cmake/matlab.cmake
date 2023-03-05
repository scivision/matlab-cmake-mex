# https://www.mathworks.com/support/requirements/supported-compilers.html
include(CheckSourceCompiles)

set(CMAKE_CXX_STANDARD 11)

add_compile_definitions($<$<AND:$<BOOL:${MSVC}>,$<COMPILE_LANGUAGE:C,CXX>>:_CRT_SECURE_NO_WARNINGS>)

if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU" AND
  CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 10)
  add_compile_options($<$<COMPILE_LANGUAGE:Fortran>:-fallow-invalid-boz>)
endif()

if(CMAKE_C_COMPILER_ID MATCHES "Clang|GNU")
  # matlab_add_mex etc. may redefine macros
  add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:-Wno-macro-redefined>)
endif()

find_package(Threads)

# MEX BLAS may need to be linked for targets using BLAS
set(_matlab_libdir_suffix)
if(MSVC)
  set(_matlab_libdir_suffix microsoft)
elseif(MINGW)
  set(_matlab_libdir_suffix mingw64)
endif()

find_library(Matlab_MEX_BLAS
NAMES libmwblas mwblas
NO_DEFAULT_PATH
PATHS ${Matlab_EXTERN_LIBRARY_DIR} ${Matlab_BINARIES_DIR}
PATH_SUFFIXES ${_matlab_libdir_suffix}
)
message(STATUS "Matlab BLAS library: ${Matlab_MEX_BLAS}")

matlab_get_mex_suffix(${Matlab_ROOT_DIR} Matlab_MEX_SUFFIX)
message(STATUS "MEX suffix: ${Matlab_MEX_SUFFIX}")

function(matlab_libpath test_names)

if(APPLE)
  set_property(TEST ${test_names} PROPERTY
  ENVIRONMENT_MODIFICATION "DYLD_LIBRARY_PATH=path_list_prepend:${Matlab_BINARIES_DIR};PATH=path_list_prepend:${Matlab_ROOT_DIR}/bin"
  )
elseif(WIN32)
  set_property(TEST ${test_names} PROPERTY
  ENVIRONMENT_MODIFICATION "PATH=path_list_prepend:${Matlab_BINARIES_DIR};PATH=path_list_prepend:${Matlab_EXTERN_BINARIES_DIR};PATH=path_list_prepend:${Matlab_ROOT_DIR}/bin"
  )
else()
  set_property(TEST ${test_names} PROPERTY
  ENVIRONMENT_MODIFICATION "LD_LIBRARY_PATH=path_list_prepend:${Matlab_BINARIES_DIR}:${Matlab_EXTERN_BINARIES_DIR}:${Matlab_ROOT_DIR}/sys/os/glnxa64;PATH=path_list_prepend:${Matlab_ROOT_DIR}/bin"
  )
endif()

endfunction(matlab_libpath)


function(check_mex lang src_file)

if(DEFINED Matlab_mex_${lang})
  return()
endif()

message(CHECK_START "Check Matlab MEX ${lang}")
execute_process(
COMMAND ${Matlab_MEX_COMPILER} -outdir ${PROJECT_BINARY_DIR}/cmake ${CMAKE_LIBRARY_PATH_FLAG}${Matlab_EXTERN_LIBRARY_DIR} ${src_file}
TIMEOUT 30
RESULT_VARIABLE ret
ERROR_VARIABLE err
OUTPUT_VARIABLE out
)
if(ret EQUAL 0)
  message(CHECK_PASS "Success")
  set(Matlab_mex_${lang} true CACHE BOOL "Matlab Mex ${lang} OK")
else()
  message(CHECK_FAIL "Failed: ${src_file}
  ${ret}
  ${out}
  ${err}")
  set(Matlab_mex_${lang} false CACHE BOOL "Matlab Mex ${lang} not working")
endif()

endfunction(check_mex)


set(CMAKE_REQUIRED_LIBRARIES ${Matlab_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})
set(CMAKE_REQUIRED_INCLUDES ${Matlab_INCLUDE_DIRS})

# --- check C engine
check_source_compiles(C
[=[
#include "engine.h"

int main(void){
	Engine *ep;
	mxArray *T = NULL;

	ep = engOpen("");
	T = mxCreateDoubleMatrix(1, 10, mxREAL);
  engClose(ep);

	return 0;
}
]=]
Matlab_engine_C
)

find_file(times_src
NAMES timestwo.c
NO_DEFAULT_PATH
PATHS ${Matlab_ROOT_DIR}/extern/examples/refbook
)
if(times_src)
  check_mex("C" ${times_src})
endif()

# --- check C++ engine

check_source_compiles(CXX
[=[
#include <cstdlib>
#include "MatlabDataArray.hpp"
#include "MatlabEngine.hpp"

int main() {
using namespace matlab::engine;
std::unique_ptr<MATLABEngine> matlabPtr = startMATLAB();
matlab::data::ArrayFactory factory;
matlab::data::TypedArray<double> data = factory.createArray<double>({ 1, 1 }, { 0 });
return EXIT_SUCCESS;
}
]=]
Matlab_engine_CXX)

find_file(array_src
NAMES arrayProduct.cpp
NO_DEFAULT_PATH
PATHS ${Matlab_ROOT_DIR}/extern/examples/cpp_mex
)
if(array_src)
  check_mex("CXX" ${array_src})
endif()

# --- check Fortran engine
if(NOT fortran)
  return()
endif()

check_source_compiles(Fortran
[=[
#include "fintrf.h"
program main
implicit none
mwPointer, external :: engOpen, mxCreateDoubleMatrix
mwPointer :: ep, T
integer, external :: engClose
integer :: ierr

ep = engOpen("")
T = mxCreateDoubleMatrix(1, 1, 0)
ierr = engClose()
end program
]=]
Matlab_engine_Fortran
)

find_file(matsq_src
NAMES matsq.F
NO_DEFAULT_PATH
PATHS ${Matlab_ROOT_DIR}/extern/examples/refbook
)

if(matsq_src)
  check_mex("Fortran" ${matsq_src})
endif()
