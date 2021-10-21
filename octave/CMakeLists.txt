set_directory_properties(PROPERTIES LABELS octave)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/Modules/)

find_package(Octave COMPONENTS Interpreter)

if(Octave_Interpreter_FOUND)
  set(octave_env)
  if(WIN32)
    cmake_path(GET Octave_EXECUTABLE PARENT_PATH Octave_DLLPATH)
    set(octave_env ${Octave_DLLPATH})
    cmake_path(APPEND_STRING octave_env ";$ENV{PATH}")
    cmake_path(CONVERT "${octave_env}" TO_NATIVE_PATH_LIST octave_env NORMALIZE)
    # this is the vital line, without it CMake set_tests_properties mangles the ENVIRONMENT
    string(REPLACE ";" "\\;" octave_env "${octave_env}")
    set(octave_env "PATH=${octave_env}")
  endif()

  add_test(NAME BasicOctave
    COMMAND ${Octave_EXECUTABLE} --eval "$<$<VERSION_GREATER_EQUAL:${Octave_VERSION},6>:o>runtests('${CMAKE_CURRENT_SOURCE_DIR}')"
  )
  set_tests_properties(BasicOctave PROPERTIES TIMEOUT 20)
endif()

# -- devel
# Fortran: https://wiki.octave.org/Fortran
find_package(Octave COMPONENTS Development)
if(Octave_Development_FOUND)
  add_executable(octdemo octdemo.cpp)
  target_link_libraries(octdemo Octave::Octave)
  target_compile_features(octdemo PRIVATE cxx_std_17)

  if(BUILD_TESTING)
    # this will fail on Windows if Octave MinGW not in PATH, which you don't want generally.
    # fix this by adding a few lines of CMake script to append to
    # ENV{PATH} the Octave MinGW bin directory and set test property ENVIRONMENT with that path.
    # be careful about escaping the path, especially if it contains spaces.
    add_test(NAME DevOctave COMMAND $<TARGET_FILE:octdemo>)
    set_tests_properties(DevOctave PROPERTIES
      TIMEOUT 10
      ENVIRONMENT "${octave_env}"
    )
  endif()
endif()
