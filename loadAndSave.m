clc; clear; close all;

%Loading .yuv, converting to RGB, back to YUV and saving (only 60 frames)


% Set the video information
videoSequence = 'BT_1024x768_cam0.yuv';
width  = 1024;
height = 768;
nFrame = 1;
max=1;


% Read the video sequence
[Y_,U_,V_] = yuvRead(videoSequence, width, height ,nFrame); 

Y_cell = cell(1,max);
U_cell = cell(1,max);
V_cell = cell(1,max);

%YUV To RGB
image = double(zeros(height, width, 3, max));

for n=1:max
for h=1:height/2
   for w=1:width/2
       
       U_mod = double(U_(h,w,n));
       V_mod = double(V_(h,w,n));
       
       i_w = (w-1)*2 + 1;
       i_h = (h-1)*2 + 1;
       Y_mod = double(Y_(i_h,i_w,n));
       [r,g,b] = YUVtoRGB(Y_mod,U_mod,V_mod);
       image(i_h,i_w,1,n) = r;
       image(i_h,i_w,2,n) = g;
       image(i_h,i_w,3,n) = b;
       
       i_w = (w-1)*2 + 1;
       i_h = (h-1)*2 + 2;
       Y_mod = double(Y_(i_h,i_w,n));
       [r,g,b] = YUVtoRGB(Y_mod,U_mod,V_mod);
       image(i_h,i_w,1,n) = r;
       image(i_h,i_w,2,n) = g;
       image(i_h,i_w,3,n) = b;
       
       i_w = (w-1)*2 + 2;
       i_h = (h-1)*2 + 1;
       Y_mod = double(Y_(i_h,i_w,n));
       [r,g,b] = YUVtoRGB(Y_mod,U_mod,V_mod);
       image(i_h,i_w,1,n) = r;
       image(i_h,i_w,2,n) = g;
       image(i_h,i_w,3,n) = b;
       
       i_w = (w-1)*2 + 2;
       i_h = (h-1)*2 + 2;
       Y_mod = double(Y_(i_h,i_w,n));
       [r,g,b] = YUVtoRGB(Y_mod,U_mod,V_mod);
       image(i_h,i_w,1,n) = r;
       image(i_h,i_w,2,n) = g;
       image(i_h,i_w,3,n) = b;
   end
end
end

%Show frame no. 1
figure()
imshow(uint8(image(:,:,:,1)));

%RGB to YUV

imageY = (zeros(height, width));
imageU = (zeros((height/2), (width/2)));
imageV = (zeros((height/2), (width/2)));


for n=1:max
    for h=1:height/2
        for w=1:width/2
            
            i_w = (w-1)*2 + 1;
            i_h = (h-1)*2 + 1;
            r1 = double(image(i_h,i_w,1,n));
            g1 = double(image(i_h,i_w,2,n));
            b1 = double(image(i_h,i_w,3,n));
            [u,v] = (RGBtoUV(r1,g1,b1));
            imageU(h,w) = u;
            imageV(h,w) = v;
            
            imageY(i_h,i_w) = RGBtoY(r1,g1,b1);
            
            i_w = (w-1)*2 + 1;
            i_h = (h-1)*2 + 2;
            r2 = double(image(i_h,i_w,1,n));
            g2 = double(image(i_h,i_w,2,n));
            b2 = double(image(i_h,i_w,3,n));
            imageY(i_h,i_w) = RGBtoY(r2,g2,b2);
            
            i_w = (w-1)*2 + 2;
            i_h = (h-1)*2 + 1;
            r3 = double(image(i_h,i_w,1,n));
            g3 = double(image(i_h,i_w,2,n));
            b3 = double(image(i_h,i_w,3,n));
            imageY(i_h,i_w) = RGBtoY(r3,g3,b3);
            
            i_w = (w-1)*2 + 2;
            i_h = (h-1)*2 + 2;
            r4 = double(image(i_h,i_w,1,n));
            g4 = double(image(i_h,i_w,2,n));
            b4 = double(image(i_h,i_w,3,n));
            imageY(i_h,i_w) = RGBtoY(r4,g4,b4);
            
        end
    end
    Y_cell(n) = mat2cell(imageY,height,width);
    U_cell(n) = mat2cell(imageU,(height/2), (width/2));
    V_cell(n) = mat2cell(imageV,(height/2), (width/2));
    
end

yuv_export(Y_cell,U_cell,V_cell,'Atestseq_1024x768.yuv',max);