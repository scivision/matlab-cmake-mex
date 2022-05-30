matlab_get_mex_suffix(${Matlab_ROOT_DIR} Matlab_MEX_SUFFIX)

if(APPLE)
  set(MATLAB_ARCH maci64)
elseif(WIN32)
  set(MATLAB_ARCH win64)
elseif(UNIX)
  set(MATLAB_ARCH glnxa64)
else()
  message(FATAL_ERROR "Unknown platform")
endif()


function(matlab_libpath test_names)

if(APPLE)
  set_tests_properties(${test_names} PROPERTIES
  ENVIRONMENT_MODIFICATION DYLD_LIBRARY_PATH=path_list_prepend:${Matlab_BINARIES_DIR}:${Matlab_ROOT_DIR}/sys/os/${MATLAB_ARCH}
  )
elseif(WIN32)
  set_tests_properties(${test_names} PROPERTIES
  ENVIRONMENT_MODIFICATION PATH=path_list_prepend:${Matlab_BINARIES_DIR}
  )
else()
  set_tests_properties(${test_names} PROPERTIES
  ENVIRONMENT_MODIFICATION LD_LIBRARY_PATH=path_list_prepend:${Matlab_BINARIES_DIR}:${Matlab_ROOT_DIR}/sys/os/${MATLAB_ARCH}
  )
endif()

endfunction(matlab_libpath)

# --- check matlab engine
# https://www.mathworks.com/support/requirements/supported-compilers.html
include(CheckSourceCompiles)


set(CMAKE_CXX_STANDARD 11)

check_source_compiles(CXX
"
#include <sstream>

int main(){
  std::stringstream s1,s2;
  s1.swap(s2);
  return EXIT_SUCCESS;
}
"
COMPILER_CXX11_OK
)

if(NOT COMPILER_CXX11_OK)
  message(WARNING "Problem with C++11 and ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
endif()

set(CMAKE_REQUIRED_LIBRARIES ${Matlab_LIBRARIES})
set(CMAKE_REQUIRED_INCLUDES ${Matlab_INCLUDE_DIRS})

check_source_compiles(CXX
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
Matlab_engine_OK
)

# --- check Fortran engine

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
