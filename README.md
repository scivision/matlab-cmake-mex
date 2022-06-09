# Matlab CMake MEX

Examples of Matlab with CMAKE and MEX producing accelerated Matlab code

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

## Apple Silicon

If using x86 Matlab on Apple Silicon CPU, you will need to configure with:

```sh
cmake -B build -DCMAKE_OSX_ARCHITECTURES=x86_64
```

In general it's better overall for Matlab to use the native ARM, which may be coming in Matlab R2022b or later.

## Reference

* [C Engine](https://www.mathworks.com/help/matlab/calling-matlab-engine-from-c-programs-1.html)
* [C++ Engine](https://www.mathworks.com/help/matlab/calling-matlab-engine-from-cpp-programs.html)
* [Fortran engine](https://www.mathworks.com/help/matlab/calling-matlab-engine-from-fortran-programs.html)

---

[GNU Octave from CMake](https://github.com/scivision/octave-cmake-mex)
