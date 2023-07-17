# Matlab CMake MEX

[![matlab](https://github.com/scivision/matlab-cmake-mex/actions/workflows/ci.yml/badge.svg)](https://github.com/scivision/matlab-cmake-mex/actions/workflows/ci.yml)

Examples of Matlab MEX and Matlab Engine via CMake using
[Matlab supported compilers](https://www.mathworks.com/support/requirements/supported-compilers.html).

One-time setup from Matlab:

```matlab
mex -setup -client engine c
mex -setup -client engine c++
mex -setup -client engine fortran
```

Build:

```sh
cmake -B build
cmake --build build

ctest --test-dir build
```

## MEX

Currently, there is a
[known CMake bug](https://gitlab.kitware.com/cmake/cmake/-/issues/25068)
with `matlab_add_mex()` for Fortran that causes runtime failures of MEX binaries.
This happens on any operating system or Fortran compiler due to the issue with CMake `matlab_add_mex()`.

```
Invalid MEX-file 'matsq.mexa64': Gateway function is missing
```

## Matlab Engine

Matlab Engine is available from several languages including C, C++, Fortran, Python, ...
Note that even for compiled Matlab Engine programs, the appropriate "matlab" executable must be in environment variable PATH.

## Linux: compiler and libstdc++ compatibility

Matlab has narrow windows of
[compiler versions](https://www.mathworks.com/support/requirements/supported-compilers-linux.html)
that work for each Matlab release.
Especially on Linux, this may require using a specific release of Matlab compatible such that Matlab libstdc++.so and system libstdc++.so are compatible.
This is because compiler-switching mechanisms like RHEL Developer Toolset still
[use system libstdc++](https://stackoverflow.com/a/69146673)
that lack newer GLIBCXX symbols.

* R2022a-R2023a: Linux: GCC 10
* R2020b-R2021b: Linux: GCC 8

A frequent issue on Linux systems is failure to link with libstdc++.so.6 correctly.
Depending on the particular Matlab version and system libstdc++, one of the following techniques may help.

Removing Matlab libstdc++:

```sh
mv <matlab_root>/sys/os/glnxa64/libstdc++.so.6 <matlab_root>/sys/os/glnxa64/libstdc++.so.6.bak
```

Putting Matlab libstdc++ first in LD_LIBRARY_PATH:

```sh
LD_LIBRARY_PATH=<matlab_root>/sys/os/glnxa64/ cmake -Bbuild
```

It may be necessary to try different Matlab versions to find one
[Linux compatible](https://www.mathworks.com/support/requirements/matlab-linux.html)
with the particular Linux operating system vendor and version.

## Apple Silicon

macOS users with Apple Silicon CPU (M1, M2, ....) are recommended to use the native Apple Silicon Matlab.
Better performance for Matlab comes by using the native CPU version of Matlab matching the computer CPU.
However, if using Intel x86 Matlab on Apple Silicon CPU:

```sh
cmake -B build -DCMAKE_OSX_ARCHITECTURES=x86_64
```

## Compiler flags

Matlab MEX compiler appears to ignore "FFLAGS" environment variable conventionally used for passing Fortran compiler flags.
This becomes an issue when needing "-fallow-invalid-boz" for GCC > 10.
Newer Matlab versions pass this flag for every GFortran MEX.

## Reference

* [C Engine](https://www.mathworks.com/help/matlab/calling-matlab-engine-from-c-programs-1.html)
* [C++ Engine](https://www.mathworks.com/help/matlab/calling-matlab-engine-from-cpp-programs.html)
* [Fortran engine](https://www.mathworks.com/help/matlab/calling-matlab-engine-from-fortran-programs.html)

---

[GNU Octave from CMake](https://github.com/scivision/octave-cmake-mex)
