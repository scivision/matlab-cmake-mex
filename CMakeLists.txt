cmake_minimum_required(VERSION 3.22)

project(MatlabMEX LANGUAGES C CXX Fortran)

enable_testing()

set(MATLAB_FIND_DEBUG true)

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()

if(APPLE AND CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
  list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
endif()

find_package(Matlab COMPONENTS MAIN_PROGRAM ENG_LIBRARY MAT_LIBRARY MX_LIBRARY MEX_COMPILER REQUIRED)

# --- Matlab paths and libs
include(cmake/matlab.cmake)

# --- Mex example
add_subdirectory(mex)

# --- Matlab Engine examples: C, C++, Fortran
add_subdirectory(engine)
