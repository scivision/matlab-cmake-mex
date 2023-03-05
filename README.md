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

## Compiler compatibility

Matlab has narrow windows of compiler versions that work for each Matlab release.
Especially on Linux, this may require using a specific release of Matlab compatible such that Matlab libstdc++.so and system libstdc++.so are compatible.

* [R2022b](https://www.mathworks.com/support/requirements/supported-compilers-linux.html): Linux: GCC 10
* [R2022a](https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/support/sysreq/files/system-requirements-release-2022a-supported-compilers.pdf): Linux: GCC 10
* [R2021b](https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/support/sysreq/files/system-requirements-release-2021b-supported-compilers.pdf): Linux: GCC 8
* [R2021a](https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/support/sysreq/files/system-requirements-release-2021a-supported-compilers.pdf): Linux: GCC 8

## Troubleshooting

### libstdc++.so.6

A frequent issue on Linux systems is failure to link with libstdc++.so.6 correctly.
We have found that changing LD_LIBRARY_PATH or using LD_PRELOAD does not help.
We have found in general that moving Matlab's softlink to libstdc++.so.6 works.

Example:

```sh
 mv <matlab_root>/sys/os/glnxa64/libstdc++.so.6 <matlab_root>/sys/os/glnxa64/libstdc++.so.6.bak
```

### Apple Silicon

macOS users with Apple Silicon CPU (M1, M2, ....) are recommended to use the native Apple Silicon Matlab.
Better performance for Matlab comes by using the native CPU version of Matlab matching the computer CPU.
However, if using Intel x86 Matlab on Apple Silicon CPU:

```sh
cmake -B build -DCMAKE_OSX_ARCHITECTURES=x86_64
```

### Compiler flags

Matlab MEX compiler appears to ignore "FFLAGS" environment variable conventionally used for passing Fortran compiler flags.
This becomes an issue when needing "-fallow-invalid-boz" for GCC > 10.
Newer Matlab versions pass this flag for every GFortran MEX.

## Reference

* [C Engine](https://www.mathworks.com/help/matlab/calling-matlab-engine-from-c-programs-1.html)
* [C++ Engine](https://www.mathworks.com/help/matlab/calling-matlab-engine-from-cpp-programs.html)
* [Fortran engine](https://www.mathworks.com/help/matlab/calling-matlab-engine-from-fortran-programs.html)

---

[GNU Octave from CMake](https://github.com/scivision/octave-cmake-mex)
