classdef TestBlas < matlab.unittest.TestCase

methods(Test)

function test_blas(tc)
a = eye(3);
b = magic(3);
x = matrixMultiply(a, b);
tc.verifyEqual(x, a*b)
end

end

end
