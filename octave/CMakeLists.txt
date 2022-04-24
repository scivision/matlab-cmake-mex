set_directory_properties(PROPERTIES LABELS octave)

find_package(Octave COMPONENTS Interpreter)

if(NOT Octave_FOUND)
  return()
endif()

add_test(NAME BasicOctave
COMMAND ${Octave_EXECUTABLE} --eval "oruntests('${CMAKE_CURRENT_SOURCE_DIR}')"
)

# -- devel
# Fortran: https://wiki.octave.org/Fortran
find_package(Octave COMPONENTS Development)
if(Octave_Development_FOUND)
  add_executable(octdemo octdemo.cpp)
  target_link_libraries(octdemo Octave::Octave)
  target_compile_features(octdemo PRIVATE cxx_std_17)

  add_test(NAME DevOctave COMMAND $<TARGET_FILE:octdemo>)

  if(WIN32 AND CMAKE_VERSION VERSION_GREATER_EQUAL 3.22)
    cmake_path(GET Octave_EXECUTABLE PARENT_PATH Octave_DLLPATH)
    set_tests_properties(DevOctave PROPERTIES ENVIRONMENT_MODIFICATION PATH=path_list_append:${Octave_DLLPATH})
  endif()
endif()


# --- props
get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)
set_tests_properties(${test_names} PROPERTIES TIMEOUT 20)
