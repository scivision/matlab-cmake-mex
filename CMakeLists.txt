cmake_minimum_required(VERSION 3.22...3.26)

project(MatlabMEX LANGUAGES C CXX)

enable_testing()

option(fortran "use fortran language too" on)

if(fortran)
  enable_language(Fortran)
endif()

message(STATUS "CMake ${CMAKE_VERSION}")

# set(MATLAB_FIND_DEBUG true)

file(GENERATE OUTPUT .gitignore CONTENT "*")

find_package(Matlab COMPONENTS MAIN_PROGRAM ENG_LIBRARY MAT_LIBRARY MX_LIBRARY MEX_COMPILER REQUIRED)

matlab_get_release_name_from_version(${Matlab_VERSION_STRING} Matlab_release)
message(STATUS "Matlab: ${Matlab_release}")

# --- Matlab paths and libs
include(cmake/matlab.cmake)

# --- Mex example
add_subdirectory(mex)

# --- Matlab Engine examples: C, C++, Fortran
add_subdirectory(engine)


include(FeatureSummary)

add_feature_info(Matlab_engine_C Matlab_engine_C "Matlab C Engine")
add_feature_info(Matlab_engine_CXX Matlab_engine_CXX "Matlab C++ Engine")
add_feature_info(Matlab_engine_Fortran Matlab_engine_Fortran "Matlab Fortran Engine")
add_feature_info(Matlab_mex_C Matlab_mex_C "Matlab C MEX")
add_feature_info(Matlab_mex_CXX Matlab_mex_CXX "Matlab C++ MEX")
add_feature_info(Matlab_mex_Fortran Matlab_mex_Fortran "Matlab Fortran MEX")


feature_summary(WHAT ENABLED_FEATURES DISABLED_FEATURES)
