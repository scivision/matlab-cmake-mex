# Matlab CMake MEX

Examples of Matlab with CMAKE and MEX producing accelerated Matlab code

## Matlab

One-time setup from Matlab:

```matlab
mex -setup -client engine C
mex -setup -client engine C++
mex -setup -client engine Fortran
```

On Windows for C/C++, MSYS2 MinGW can be used by setting environment variable:

```
MW_MINGW_LOC=C:/msys64/mingw64
```

confirm location of GCC on Windows like:

```pwsh
where.exe gcc
```

## GNU Octave

[Octave from CMake](./octave) via our
[FindOctave.cmake](./cmake/Modules/FindOctave.cmake)
works for unit tests, liboctave, etc.
