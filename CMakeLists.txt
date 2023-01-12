cmake_minimum_required(VERSION 3.22...3.25)

project(MatlabMEX LANGUAGES C CXX)

enable_testing()

option(fortran "use fortran language too" on)

if(fortran)
  enable_language(Fortran)
endif()

# set(MATLAB_FIND_DEBUG true)

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
