set_directory_properties(PROPERTIES LABELS octave)

find_package(Octave COMPONENTS Development Interpreter)

if(NOT Octave_FOUND)
  return()
endif()

add_test(NAME BasicOctave
COMMAND ${Octave_EXECUTABLE} --eval "oruntests('${CMAKE_CURRENT_SOURCE_DIR}')"
)

# -- devel
# Fortran: https://wiki.octave.org/Fortran
set(CMAKE_REQUIRED_LIBRARIES ${Octave_LIBRARIES})
set(CMAKE_REQUIRED_INCLUDES ${Octave_INCLUDE_DIRS})
check_source_compiles(CXX
"
#include <oct.h>

int main()
{
 Matrix a_matrix = Matrix (2, 2);
 return EXIT_SUCCESS;
}
"
Octave_STDCXX_OK
)

if(Octave_STDCXX_OK)

add_executable(octdemo octdemo.cpp)
target_link_libraries(octdemo Octave::Octave)
target_compile_features(octdemo PRIVATE cxx_std_11)

add_test(NAME DevOctave COMMAND octdemo)

if(WIN32)
  cmake_path(GET Octave_EXECUTABLE PARENT_PATH Octave_DLLPATH)
  set_tests_properties(DevOctave PROPERTIES ENVIRONMENT_MODIFICATION PATH=path_list_append:${Octave_DLLPATH})
endif()

endif(Octave_STDCXX_OK)

# --- props
get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)
set_tests_properties(${test_names} PROPERTIES TIMEOUT 20)
