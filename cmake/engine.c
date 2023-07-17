#include "engine.h"

int main(void){
Engine *ep;
mxArray *T = NULL;

ep = engOpen("");
T = mxCreateDoubleMatrix(1, 10, mxREAL);
engClose(ep);

return 0;
}
