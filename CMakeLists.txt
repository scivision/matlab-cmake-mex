cmake_minimum_required(VERSION 3.22)

project(MatlabMEX LANGUAGES C CXX Fortran)

enable_testing()

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()


find_package(Matlab COMPONENTS MAIN_PROGRAM ENG_LIBRARY MAT_LIBRARY MX_LIBRARY MEX_COMPILER REQUIRED)

# --- Matlab paths and libs
include(cmake/matlab.cmake)

# --- Mex example
add_subdirectory(mex)

# --- Matlab Engine examples: C, C++, Fortran
add_subdirectory(engine)
