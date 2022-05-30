# --- C calling Matlab Engine

if(Matlab_engine_C)

add_executable(engdemo_c engdemo.c)
target_include_directories(engdemo_c PRIVATE ${Matlab_INCLUDE_DIRS})
target_link_libraries(engdemo_c PRIVATE ${Matlab_ENG_LIBRARY} ${Matlab_MX_LIBRARY})

# matlab_add_mex(NAME engdemo_c EXECUTABLE SRC engdemo.c LINK_TO ${Matlab_LIBRARIES})

add_test(NAME Engine_C COMMAND engdemo_c)

endif(Matlab_engine_C)

# --- Fortran calling Matlab Engine

if(Matlab_engine_Fortran)
  add_executable(eng_f fengdemo.F90)
  target_include_directories(eng_f PRIVATE ${Matlab_INCLUDE_DIRS})
  target_link_libraries(eng_f PRIVATE ${Matlab_LIBRARIES})

  add_test(NAME Engine_Fortran COMMAND eng_f)
endif(Matlab_engine_Fortran)

# --- Engine test props

get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)
set_tests_properties(${test_names} PROPERTIES TIMEOUT 90)

matlab_libpath("${test_names}")
