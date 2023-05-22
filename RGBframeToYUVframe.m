function [Y, U, V] = RGBframeToYUVframe(image, width, height)
%RGBFRAMETOYUVFRAME Summary of this function goes here
%   Detailed explanation goes here

imageY = (zeros(height, width));
imageU = (zeros((height/2), (width/2)));
imageV = (zeros((height/2), (width/2)));

for h=1:height/2
        for w=1:width/2
            
            i_w = (w-1)*2 + 1;
            i_h = (h-1)*2 + 1;
            r1 = double(image(i_h,i_w,1));
            g1 = double(image(i_h,i_w,2));
            b1 = double(image(i_h,i_w,3));
            [u,v] = (RGBtoUV(r1,g1,b1));
            imageU(h,w) = u;
            imageV(h,w) = v;
            
            imageY(i_h,i_w) = RGBtoY(r1,g1,b1);
            
            i_w = (w-1)*2 + 1;
            i_h = (h-1)*2 + 2;
            r2 = double(image(i_h,i_w,1));
            g2 = double(image(i_h,i_w,2));
            b2 = double(image(i_h,i_w,3));
            imageY(i_h,i_w) = RGBtoY(r2,g2,b2);
            
            i_w = (w-1)*2 + 2;
            i_h = (h-1)*2 + 1;
            r3 = double(image(i_h,i_w,1));
            g3 = double(image(i_h,i_w,2));
            b3 = double(image(i_h,i_w,3));
            imageY(i_h,i_w) = RGBtoY(r3,g3,b3);
            
            i_w = (w-1)*2 + 2;
            i_h = (h-1)*2 + 2;
            r4 = double(image(i_h,i_w,1));
            g4 = double(image(i_h,i_w,2));
            b4 = double(image(i_h,i_w,3));
            imageY(i_h,i_w) = RGBtoY(r4,g4,b4);
            
        end
    end
Y = imageY;
U = imageU;
V = imageV;
end

