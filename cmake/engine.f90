#include "fintrf.h"

program main
implicit none
mwPointer, external :: engOpen, mxCreateDoubleMatrix
mwPointer :: ep, T
integer, external :: engClose
integer :: ierr

ep = engOpen("")
T = mxCreateDoubleMatrix(1, 1, 0)
ierr = engClose()
end program
