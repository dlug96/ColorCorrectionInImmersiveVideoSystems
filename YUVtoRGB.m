function [R, G, B] = YUVtoRGB(Y, U, V)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
y = double(Y);
u = double(U-128);
v = double(V-128);

v1 = (1.370705 * v);
v2 = (0.698001 * v);
u1 = (0.337633 * (u));
u2 = (1.732446 * u);

r = int16(y + v1);
g = int16(y - v2 - u1);
b = int16(y + u2);

R = uint8(r);
G = uint8(g);
B = uint8(b);

end

