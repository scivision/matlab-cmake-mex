# sets include paths needed for each OS with Matlab Engine

if(WIN32)
  set(libenv ${Matlab_ROOT_DIR}/bin/win64/)
  cmake_path(APPEND_STRING libenv ";$ENV{PATH}")
  cmake_path(CONVERT "${libenv}" TO_NATIVE_PATH_LIST libenv NORMALIZE)
  # this is the vital line, without it CMake set_tests_properties mangles the ENVIRONMENT
  string(REPLACE ";" "\\;" libenv "${libenv}")
  set(libenv "PATH=${libenv}")
elseif(APPLE)
  set(libenv "DYLD_LIBRARY_PATH=${libpath}:${ospath}:$ENV{DYLD_LIBRARY_PATH}")
elseif(UNIX)
  # https://www.mathworks.com/help/matlab/matlab_external/building-on-unix-operating-systems.html
  set(libenv "LD_LIBRARY_PATH=${libpath}:${ospath}:$ENV{LD_LIBRARY_PATH}")
endif()
