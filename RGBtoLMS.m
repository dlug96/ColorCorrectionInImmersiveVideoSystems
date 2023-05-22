function [L, M, S] = RGBtoLMS(R, G, B)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
L = 0.3811*R + 0.5783*G + 0.0402*B;
M = 0.1967*R + 0.7244*G + 0.0782*B;
S = 0.0241*R + 0.1228*G + 0.8444*B;
end
