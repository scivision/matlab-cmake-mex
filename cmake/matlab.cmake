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


set(CMAKE_REQUIRED_LIBRARIES ${Matlab_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})
set(CMAKE_REQUIRED_INCLUDES ${Matlab_INCLUDE_DIRS})

# --- check C engine
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

check_source_compiles(Fortran
[=[
#include "fintrf.h"
program main
implicit none
mwPointer, external :: engOpen, engGetVariable, mxCreateDoubleMatrix
mwPointer, external :: mxGetDoubles
mwSize, parameter :: M=1
mwPointer :: ep, T
integer, external :: engPutVariable, engEvalString, engClose

ep = engOpen("")
T = mxCreateDoubleMatrix(1, 1, 0)
end program
]=]
Matlab_engine_Fortran
)
