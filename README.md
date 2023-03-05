# Matlab CMake MEX

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

## Matlab Engine

Matlab Engine is available from several languages including C, C++, Fortran, Python, ...
Note that even for compiled Matlab Engine programs, the appropriate "matlab" executable must be in environment variable PATH.

## Apple Silicon

macOS users with Apple Silicon CPU (M1, M2, ....) are recommended to use the native Apple Silicon Matlab.
Better performance for Matlab comes by using the native CPU version of Matlab matching the computer CPU.
However, if using Intel x86 Matlab on Apple Silicon CPU:

```sh
cmake -B build -DCMAKE_OSX_ARCHITECTURES=x86_64
```

## Reference

Matlab MEX compiler appears to ignore "FFLAGS" environment variable conventionally used for passing Fortran compiler flags.
This becomes an issue when needing "-fallow-invalid-boz" for GCC > 10.
Newer Matlab versions pass this flag for every Gfortran MEX.

* [C Engine](https://www.mathworks.com/help/matlab/calling-matlab-engine-from-c-programs-1.html)
* [C++ Engine](https://www.mathworks.com/help/matlab/calling-matlab-engine-from-cpp-programs.html)
* [Fortran engine](https://www.mathworks.com/help/matlab/calling-matlab-engine-from-fortran-programs.html)

---

[GNU Octave from CMake](https://github.com/scivision/octave-cmake-mex)
