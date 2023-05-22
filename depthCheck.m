function [result] = depthCheck(depthReal,depthVirtual)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

d1 = double(depthReal);
d2 = double(depthVirtual);

if(abs(d1 - d2) <= 2560)
    result = 1;
else
    result = 0;
end

end

