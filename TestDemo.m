classdef TestDemo < matlab.unittest.TestCase

methods(Test)

function test_true(tc)
tc.assertTrue(true)
end

function test_blas(tc)
a = eye(3);
b = magic(3);
x = matrixMultiply(a, b);
disp(x)
end

end

end
