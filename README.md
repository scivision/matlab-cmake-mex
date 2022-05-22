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

[GNU Octave from CMake](https://github.com/scivision/octave-cmake-mex)
