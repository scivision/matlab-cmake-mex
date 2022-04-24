cmake_minimum_required(VERSION 3.22...3.23)

project(demoMatlab LANGUAGES C CXX Fortran)

enable_testing()

cmake_path(SET CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/)

add_subdirectory(matlab)
add_subdirectory(octave)
