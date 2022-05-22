cmake_minimum_required(VERSION 3.22)

project(demoMatlab LANGUAGES C CXX Fortran)

enable_testing()

include(CheckSourceCompiles)

cmake_path(SET CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/)

add_subdirectory(matlab)
add_subdirectory(octave)
