# Matlab CMake MEX

Examples of Matlab with CMAKE and MEX producing accelerated Matlab code

## Matlab

One-time setup: if you've never used `mex` before, you must setup the C++ compiler.
It doesn't hurt to do this again if you're not sure.
From Matlab:

```matlab
mex -setup -client engine C++
```

Will ask you to select a compiler, or simply return:

> ENGINE configured to use 'g++' for C++ language compilation.

## GNU Octave

[Octave from CMake](./octave) via our
[FindOctave.cmake](./cmake/Modules/FindOctave.cmake)
works for unit tests, liboctave, etc.
