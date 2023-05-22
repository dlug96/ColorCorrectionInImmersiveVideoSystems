function [RGB] = YUVframeToRGBframe(Y_, U_, V_, width, height)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

image = double(zeros(height, width, 3));

for h=1:height/2
   for w=1:width/2
       
       U_mod = double(U_(h,w));
       V_mod = double(V_(h,w));
       
       i_w = (w-1)*2 + 1;
       i_h = (h-1)*2 + 1;
       Y_mod = double(Y_(i_h,i_w));
       [r,g,b] = YUVtoRGB(Y_mod,U_mod,V_mod);
       image(i_h,i_w,1) = r;
       image(i_h,i_w,2) = g;
       image(i_h,i_w,3) = b;
       
       i_w = (w-1)*2 + 1;
       i_h = (h-1)*2 + 2;
       Y_mod = double(Y_(i_h,i_w));
       [r,g,b] = YUVtoRGB(Y_mod,U_mod,V_mod);
       image(i_h,i_w,1) = r;
       image(i_h,i_w,2) = g;
       image(i_h,i_w,3) = b;
       
       i_w = (w-1)*2 + 2;
       i_h = (h-1)*2 + 1;
       Y_mod = double(Y_(i_h,i_w));
       [r,g,b] = YUVtoRGB(Y_mod,U_mod,V_mod);
       image(i_h,i_w,1) = r;
       image(i_h,i_w,2) = g;
       image(i_h,i_w,3) = b;
       
       i_w = (w-1)*2 + 2;
       i_h = (h-1)*2 + 2;
       Y_mod = double(Y_(i_h,i_w));
       [r,g,b] = YUVtoRGB(Y_mod,U_mod,V_mod);
       image(i_h,i_w,1) = r;
       image(i_h,i_w,2) = g;
       image(i_h,i_w,3) = b;
   end
end

RGB = uint8(image);

end

