# sets include paths needed for each OS with Matlab Engine

if(WIN32)
  set(libpath ${Matlab_ROOT_DIR}/bin/win64/)
   # no ospath on Windows
  set(libenv ${libpath})
  cmake_path(APPEND_STRING libenv ";$ENV{PATH}")
  cmake_path(CONVERT "${libenv}" TO_NATIVE_PATH_LIST libenv NORMALIZE)
  # this is the vital line, without it CMake set_tests_properties mangles the ENVIRONMENT
  string(REPLACE ";" "\\;" libenv "${libenv}")
  set(libenv "PATH=${libenv}")

  set(mexext .mexw64)
elseif(APPLE)
  set(libpath ${Matlab_ROOT_DIR}/bin/maci64/)
  set(ospath ${Matlab_ROOT_DIR}/sys/os/maci64/)
  set(libenv "DYLD_LIBRARY_PATH=${libpath}:${ospath}:$ENV{DYLD_LIBRARY_PATH}")
  set(mexext .mexmaci64)
elseif(UNIX)
  # https://www.mathworks.com/help/matlab/matlab_external/building-on-unix-operating-systems.html
  set(libpath ${Matlab_ROOT_DIR}/bin/glnxa64/)
  set(ospath ${Matlab_ROOT_DIR}/sys/os/glnxa64/)
  set(libenv "LD_LIBRARY_PATH=${libpath}:${ospath}:$ENV{LD_LIBRARY_PATH}")
  set(mexext .mexa64)
endif()

# message(STATUS "libpath:  ${libpath}")
# message(STATUS "libenv:   ${libenv}")
