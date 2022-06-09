# https://www.mathworks.com/support/requirements/supported-compilers.html
include(CheckSourceCompiles)

set(CMAKE_CXX_STANDARD 11)

find_package(Threads)

matlab_get_mex_suffix(${Matlab_ROOT_DIR} Matlab_MEX_SUFFIX)


function(matlab_libpath test_names)

if(APPLE)
  set_tests_properties(${test_names} PROPERTIES
  ENVIRONMENT_MODIFICATION DYLD_LIBRARY_PATH=path_list_prepend:${Matlab_BINARIES_DIR}
  )
elseif(WIN32)
  set_tests_properties(${test_names} PROPERTIES
  ENVIRONMENT_MODIFICATION "PATH=path_list_prepend:${Matlab_BINARIES_DIR};PATH=path_list_prepend:${Matlab_EXTERN_BINARIES_DIR}"
  )
else()
  set_tests_properties(${test_names} PROPERTIES
  ENVIRONMENT_MODIFICATION LD_LIBRARY_PATH=path_list_prepend:${Matlab_BINARIES_DIR}:${Matlab_EXTERN_BINARIES_DIR}:${Matlab_ROOT_DIR}/sys/os/glnxa64
  )
endif()

endfunction(matlab_libpath)

# --- check C engine

set(CMAKE_REQUIRED_LIBRARIES ${Matlab_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})
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

# --- check C++ engine

set(CMAKE_REQUIRED_LIBRARIES ${Matlab_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})

check_source_compiles(CXX
[=[
#include "MatlabDataArray.hpp"
#include "MatlabEngine.hpp"

int main() {
    using namespace matlab::engine;
    std::unique_ptr<MATLABEngine> matlabPtr = startMATLAB();
    matlab::data::ArrayFactory factory;

    // Create variables
    matlab::data::TypedArray<double> data = factory.createArray<double>({ 1, 10 },
        { 4, 8, 6, -1, -2, -3, -1, 3, 4, 5 });

    return EXIT_SUCCESS;
}
]=]
Matlab_engine_CXX)

# --- check Fortran engine

if(NOT DEFINED Matlab_engine_Fortran)
  if((WIN32 OR APPLE) AND NOT CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")
    message(STATUS "SKIP: on Windows and MacOS, Matlab Engine Fortran supports only Intel compiler.")
    set(Matlab_engine_Fortran false CACHE BOOL "Matlab Fortran engine")
  elseif(CMAKE_SYSTEM_NAME STREQUAL Linux AND NOT CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
    message(STATUS "SKIP: On Linux, Matlab Engine Fortran supports only Gfortran.")
    set(Matlab_engine_Fortran false CACHE BOOL "Matlab Fortran engine")
  else()
    message(CHECK_START "Performing Test Matlab_engine_Fortran")
    try_compile(Matlab_engine_Fortran
    ${CMAKE_CURRENT_BINARY_DIR}/engine_fortran
    ${CMAKE_CURRENT_SOURCE_DIR}/src/eng_demo.F90
    CMAKE_FLAGS "-DINCLUDE_DIRECTORIES:PATH=${Matlab_INCLUDE_DIRS}"
    LINK_LIBRARIES ${Matlab_ENG_LIBRARY} ${Matlab_MX_LIBRARY}
    OUTPUT_VARIABLE err
    )
    if(Matlab_engine_Fortran)
      set(Matlab_engine_Fortran true CACHE BOOL "Matlab Fortran engine")
      message(CHECK_PASS "Success")
    else()
      set(Matlab_engine_Fortran false CACHE BOOL "Matlab Fortran engine")
      message(CHECK_FAIL "Failed")
      message(STATUS "${err}")
    endif()
  endif()
endif()
