# --- C calling Matlab Engine

if(Matlab_engine_C)

add_executable(engine_c engdemo.c)
target_include_directories(engine_c PRIVATE ${Matlab_INCLUDE_DIRS})
target_link_libraries(engine_c PRIVATE ${Matlab_ENG_LIBRARY} ${Matlab_MX_LIBRARY})

# matlab_add_mex(NAME engine_c EXECUTABLE SRC engdemo.c LINK_TO ${Matlab_LIBRARIES})

add_test(NAME Engine_C COMMAND engine_c)

endif(Matlab_engine_C)

# --- C++ calling Matlab engine

if(Matlab_engine_CXX)

add_executable(engine_cpp eng_demo.cpp)
target_include_directories(engine_cpp PRIVATE ${Matlab_INCLUDE_DIRS})
target_link_libraries(engine_cpp PRIVATE ${Matlab_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})

# matlab_add_mex(NAME engine_cpp EXECUTABLE SRC eng_demo.cpp LINK_TO ${Matlab_LIBRARIES})

# add_custom_target(engine_cpp ALL
# COMMAND ${Matlab_MEX_COMPILER} -client engine ${CMAKE_CURRENT_SOURCE_DIR}/eng_demo.cpp
# BYPRODUCTS engine_cpp${CMAKE_EXECUTABLE_SUFFIX}
# )

add_test(NAME Engine_CPP COMMAND engine_cpp)

endif(Matlab_engine_CXX)

# --- Fortran calling Matlab Engine

if(Matlab_engine_Fortran)
  add_executable(engine_fortran eng_demo.F90)
  target_include_directories(engine_fortran PRIVATE ${Matlab_INCLUDE_DIRS})
  target_link_libraries(engine_fortran PRIVATE ${Matlab_LIBRARIES})

  add_test(NAME Engine_Fortran COMMAND engine_fortran)
endif(Matlab_engine_Fortran)

# --- Engine test props

get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)
set_tests_properties(${test_names} PROPERTIES TIMEOUT 90)

matlab_libpath("${test_names}")
