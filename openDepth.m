clear; clc; close all;

% Paramtry wczytywanych sekewencji

width  = 1024;
height = 768;
nFrame = 10;

view0 = 'BT_1024x768_cam0.yuv';
view0_depth = 'BTd_1024x768_16bps_cf400_cam0.yuv';
view1 = 'BT_1024x768_cam1.yuv';

vid = view0_depth;

fid = fopen(vid,'r');           % Open the video file
stream = fread(fid,'*uint16');    % Read the video file
length = 1.5 * width * height;  % Length of a single frame

y = uint16(zeros(height,   width,   nFrame));
u = uint16(zeros(height/2, width/2, nFrame));
v = uint16(zeros(height/2, width/2, nFrame));

for iFrame = 1:nFrame
    
    frame = stream((iFrame-1)*length+1:iFrame*length);
    
    % Y component of the frame
    yImage = reshape(frame(1:width*height), width, height)';
    % U component of the frame
    uImage = reshape(frame(width*height+1:1.25*width*height), width/2, height/2)';
    % V component of the frame
    vImage = reshape(frame(1.25*width*height+1:1.5*width*height), width/2, height/2)';
    
    y(:,:,iFrame) = uint16(yImage);
    u(:,:,iFrame) = uint16(uImage);
    v(:,:,iFrame) = uint16(vImage);

end
image=zeros(height,width);
for n=1:nFrame
   if(mod(n,2)==0)
       image(1:height/2,:) = y(height/2+1:height,:,n);
       image(height/2+1:height,:) = y(1:height/2,:,n);
       y(:,:,n)=image;
   end
end
figure()
imshow(y(:,:))
