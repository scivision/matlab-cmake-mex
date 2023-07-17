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
