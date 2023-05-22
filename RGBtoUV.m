function [U,V] = RGBtoUV(R,G,B)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
V = 0.500*R - 0.419*G - 0.081*B+128;
U = -0.169*R - 0.331*G + 0.500*B+128;
end

