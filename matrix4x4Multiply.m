function [C] = matrix4x4Multiply(A,B)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
C = zeros(4);
for i=1:4
    for j=1:4
        C(i,j) = 0;
        for k=1:4
           C(i,j) = C(i,j)+ (A(i, k) * B(k, j)); 
        end
    end
end
end

