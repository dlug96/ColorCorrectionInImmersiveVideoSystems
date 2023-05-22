function [T] = convertVecorT(RT)
%convertVectorT Multiplies matrix R by vector T
%   Detailed explanation goes here
R = zeros(3,3);
R(1,1:3) = RT(1,1:3);
R(2,1:3) = RT(2,1:3);
R(3,1:3) = RT(3,1:3);
T = RT(1:3,4);

T = -1*R*T;
end

