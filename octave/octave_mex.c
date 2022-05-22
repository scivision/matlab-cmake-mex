#include "stdio.h"
#include "mex.h"

/* https://octave.org/doc/latest/Getting-Started-with-Mex_002dFiles.html */

int main(void){
 mxArray **plhs = mxCreateDoubleMatrix (0, 0, mxREAL);
 printf("OK: Octave C\n");
 return 0;
}
