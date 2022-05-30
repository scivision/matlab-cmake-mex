matlab_get_mex_suffix(${Matlab_ROOT_DIR} Matlab_MEX_SUFFIX)


function(matlab_libpath test_names)

if(APPLE)
  set_tests_properties(${test_names} PROPERTIES
  ENVIRONMENT_MODIFICATION DYLD_LIBRARY_PATH=path_list_prepend:${Matlab_BINARIES_DIR}
  )
elseif(WIN32)
  set_tests_properties(${test_names} PROPERTIES
  ENVIRONMENT_MODIFICATION PATH=path_list_prepend:${Matlab_BINARIES_DIR}
  )
else()
  set_tests_properties(${test_names} PROPERTIES
  ENVIRONMENT_MODIFICATION LD_LIBRARY_PATH=path_list_prepend:${Matlab_BINARIES_DIR}:${Matlab_ROOT_DIR}/sys/os/glnxa64
  )
endif()

endfunction(matlab_libpath)

# --- check matlab engine
# https://www.mathworks.com/support/requirements/supported-compilers.html
include(CheckSourceCompiles)

set(CMAKE_REQUIRED_LIBRARIES ${Matlab_ENG_LIBRARY} ${Matlab_MX_LIBRARY})
set(CMAKE_REQUIRED_INCLUDES ${Matlab_INCLUDE_DIRS})

check_source_compiles(C
[=[
#include "engine.h"

int main(){
	Engine *ep;
	mxArray *T = NULL;

	ep = engOpen("");
	T = mxCreateDoubleMatrix(1, 10, mxREAL);
	return 0;
}
]=]
Matlab_engine_C
)

# --- check Fortran engine

if((WIN32 OR APPLE) AND NOT CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")
  message(STATUS "SKIP: on Windows and MacOS, Matlab Engine Fortran supports only Intel compiler.")
  set(Matlab_engine_Fortran false CACHE BOOL "Matlab Fortran engine")
elseif(UNIX AND NOT CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  message(STATUS "SKIP: On Linux, Matlab Engine Fortran supports only Gfortran.")
  set(Matlab_engine_Fortran false CACHE BOOL "Matlab Fortran engine")
else()
  check_source_compiles(Fortran
  [=[
  #include "fintrf.h"

  program main

  implicit none (type,external)

  mwPointer, external :: engOpen, mxCreateDoubleMatrix
  mwPointer :: ep, T
  integer, external :: engClose
  integer :: status

  ep = engOpen("")

  T = mxCreateDoubleMatrix(2, 1, 0)

  status = engClose(ep)

  end program
  ]=]
  Matlab_engine_Fortran
  )
endif()
