function [y] = fixDepth(y, width, height, nFrame)
%fixDepth Fixes every other frame
%   Detailed explanation goes here
image=zeros(height,width);
for n=1:nFrame
   if(mod(n,2)==0)
       image(1:height/2,:) = y(height/2+1:height,:,n);
       image(height/2+1:height,:) = y(1:height/2,:,n);
       y(:,:,n)=image;
   end
end
end

