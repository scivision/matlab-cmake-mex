cmake_minimum_required(VERSION 3.22)

project(MatlabMEX LANGUAGES C CXX Fortran)

enable_testing()

find_package(Matlab COMPONENTS MAIN_PROGRAM ENG_LIBRARY MX_LIBRARY MEX_COMPILER REQUIRED)

add_test(NAME Matlab_script
COMMAND ${Matlab_MAIN_PROGRAM} -batch "r=runtests('${CMAKE_CURRENT_SOURCE_DIR}', 'Name', 'TestDemo/test_true'); assertSuccess(r)"
)

add_subdirectory(src)
