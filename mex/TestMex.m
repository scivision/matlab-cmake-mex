classdef TestMex < matlab.unittest.TestCase

methods(Test)

function test_blas(tc)
a = eye(3);
b = magic(3);
x = matrixMultiply(a, b);
tc.verifyEqual(x, a*b)
end

function test_cpp_array(tc)
a = eye(3);
x = arrayProduct(2, a);
tc.verifyEqual(x, 2*a)
end

function test_fortran_mex(tc)

a = eye(3);
x = matsq(a);
tc.verifyEqual(x, a.^2)

end

end

end
