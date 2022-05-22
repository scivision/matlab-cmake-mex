# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindOctave
----------

Finds GNU Octave interpreter, libraries and compilers.

Imported targets
^^^^^^^^^^^^^^^^

This module defines the following :prop_tgt:`IMPORTED` targets:

``Octave::Interpreter``
  Octave interpreter (the main program)
``Octave::Octave``
  include directories and libraries

If no ``COMPONENTS`` are specified, ``Interpreter`` is assumed.

Result Variables
^^^^^^^^^^^^^^^^

``Octave_FOUND``
  Octave interpreter and/or libraries were found
``Octave_<component>_FOUND``
  Octave <component> specified was found

``Octave_EXECUTABLE``
  Octave interpreter
``Octave_INCLUDE_DIRS``
  include path for mex.h
``Octave_LIBRARIES``
  octinterp, octave libraries


Cache variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Octave_INTERP_LIBRARY``
  path to the library octinterp
``Octave_OCTAVE_LIBRARY``
  path to the liboctave library


Hints
^^^^^

FindOctave checks the environment variable OCTAVE_EXECUTABLE for the
Octave interpreter.
#]=======================================================================]

unset(_hint)
if(DEFINED ENV{OCTAVE_EXECUTABLE})
  get_filename_component(_hint $ENV{OCTAVE_EXECUTABLE} DIRECTORY)
endif()

unset(_hint_dir)
unset(_path)
unset(_suff)
if(WIN32)
  set(_suff mingw64/bin)
  set(_path "$ENV{ProgramFiles}/GNU Octave")
  if(IS_DIRECTORY ${_path})
    file(GLOB_RECURSE _hint_dir "${_path}/Octave-*/mingw64/bin/octave-cli.exe")
  else()
    unset(_path)
  endif()
endif()

find_program(Octave_CONFIG_EXECUTABLE
NAMES octave-config
HINTS ${_hint} ${_hint_dir}
PATHS ${_path}
PATH_SUFFIXES ${_suff}
)

if(Octave_CONFIG_EXECUTABLE)
  execute_process(COMMAND ${Octave_CONFIG_EXECUTABLE} -p BINDIR
  OUTPUT_VARIABLE Octave_BINARY_DIR
  ERROR_QUIET
  OUTPUT_STRIP_TRAILING_WHITESPACE
  TIMEOUT 5
  )

  execute_process(COMMAND ${Octave_CONFIG_EXECUTABLE} -p VERSION
  OUTPUT_VARIABLE Octave_VERSION
  ERROR_QUIET
  OUTPUT_STRIP_TRAILING_WHITESPACE
  TIMEOUT 5
  )
endif()

if(Development IN_LIST Octave_FIND_COMPONENTS)

  if(Octave_CONFIG_EXECUTABLE)
    execute_process(COMMAND ${Octave_CONFIG_EXECUTABLE} -p OCTINCLUDEDIR
    OUTPUT_VARIABLE Octave_INCLUDE_DIR
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
    TIMEOUT 5
    )

    execute_process(COMMAND ${Octave_CONFIG_EXECUTABLE} -p OCTLIBDIR
    OUTPUT_VARIABLE Octave_LIB1
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
    TIMEOUT 5
    )

    execute_process(COMMAND ${Octave_CONFIG_EXECUTABLE} -p LIBDIR
    OUTPUT_VARIABLE Octave_LIB2
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
    TIMEOUT 5
    )
  endif(Octave_CONFIG_EXECUTABLE)

  find_library(Octave_INTERP_LIBRARY
  NAMES octinterp
  HINTS ${Octave_LIB1} ${Octave_LIB2}
  )
  find_library(Octave_OCTAVE_LIBRARY
  NAMES octave
  HINTS ${Octave_LIB1} ${Octave_LIB2}
  )

  if(Octave_INTERP_LIBRARY AND Octave_OCTAVE_LIBRARY)
    set(Octave_Development_FOUND true)
  endif()

endif()

if(Interpreter IN_LIST Octave_FIND_COMPONENTS)

  find_program(Octave_EXECUTABLE
  NAMES octave-cli octave
  HINTS ${Octave_BINARY_DIR} ${_hint} ${_hint_dir}
  PATHS ${_path}
  PATH_SUFFIXES ${_suff}
  )

  if(Octave_EXECUTABLE)
    set(Octave_Interpreter_FOUND true)
  endif(Octave_EXECUTABLE)

endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Octave
VERSION_VAR Octave_VERSION
HANDLE_COMPONENTS
HANDLE_VERSION_RANGE
)


if(Octave_Development_FOUND)
  set(Octave_LIBRARIES ${Octave_INTERP_LIBRARY} ${Octave_OCTAVE_LIBRARY})
  set(Octave_INCLUDE_DIRS ${Octave_INCLUDE_DIR})

  if(NOT TARGET Octave::Octave)
    add_library(Octave::Octave INTERFACE IMPORTED)
    set_target_properties(Octave::Octave PROPERTIES
    INTERFACE_LINK_LIBRARIES "${Octave_INTERP_LIBRARY};${Octave_OCTAVE_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES ${Octave_INCLUDE_DIR}
    )
  endif()

endif()


if(Octave_Interpreter_FOUND)
  if(NOT TARGET Octave::Interpreter)
    add_executable(Octave::Interpreter IMPORTED)
    set_target_properties(Octave::Interpreter PROPERTIES
    IMPORTED_LOCATION ${Octave_EXECUTABLE}
    VERSION "${Octave_VERSION}"
    )
  endif()
endif()

mark_as_advanced(
Octave_CONFIG_EXECUTABLE
Octave_INTERP_LIBRARY
Octave_OCTAVE_LIBRARY
Octave_INCLUDE_DIR
)
