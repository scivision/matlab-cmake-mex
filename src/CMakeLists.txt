# https://www.mathworks.com/support/requirements/supported-compilers.html
include(CheckSourceCompiles)

# --- C calling Matlab Engine

set(CMAKE_REQUIRED_LIBRARIES ${Matlab_LIBRARIES})
set(CMAKE_REQUIRED_INCLUDES ${Matlab_INCLUDE_DIRS})
check_source_compiles(C
[=[
#include "engine.h"

int main(void){
	Engine *ep;
	mxArray *T = NULL;

	ep = engOpen("");
	T = mxCreateDoubleMatrix(1, 10, mxREAL);
	return 0;
}
]=]
Matlab_engine_OK
)

if(Matlab_engine_OK)

add_executable(engdemo_c engdemo.c)
target_include_directories(engdemo_c PRIVATE ${Matlab_INCLUDE_DIRS})
target_link_libraries(engdemo_c PRIVATE ${Matlab_LIBRARIES})

add_test(NAME MatlabEngine_C COMMAND engdemo_c)

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
  add_executable(eng_f fengdemo.F90)
  target_include_directories(eng_f PRIVATE ${Matlab_INCLUDE_DIRS})
  target_link_libraries(eng_f PRIVATE ${Matlab_LIBRARIES})

  add_test(NAME MatlabEngine_Fortran COMMAND eng_f)
endif()

endif(Matlab_engine_OK)

# --- Engine test props

get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)
set_tests_properties(${test_names} PROPERTIES TIMEOUT 90)

matlab_libpath(${test_names})
