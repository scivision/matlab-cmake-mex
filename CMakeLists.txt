cmake_minimum_required(VERSION 3.20...3.23)

project(demoMatlab LANGUAGES C CXX Fortran)

include(CTest)

cmake_path(SET CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/)

add_subdirectory(matlab)
add_subdirectory(octave)
