clear; clc; close all;

% Paramtry wczytywanych sekewencji

width  = 1280;
height = 768;
nFrame = 1;

view0 = 'BBBF_1280x768_cam06.yuv';
view0_depth = 'BBBFd_1280x768_16bps_cf400_cam06.yuv';
view1 = 'BBBF_1280x768_cam19.yuv';
% view1_depth = 'BTd_1024x768_16bps_cf400_cam1.yuv';

% Parametry kamer (r - rzeczywista, v - wirtualna)

%Macierze parametrów wewnêtrznych 
% Kr = [1918.270000,	2.489820,	494.085000, 0;	
%     0,	-1922.580000,	320.264, 0;
%     0,	0,	1, 0;
%     0, 0, 0, 1];
% Kv = [1913.690000,	-0.143610,	533.307000, 0;	
%     0,	-1918.170000,	369.829, 0;	
%     0,	0,	1, 0;
%     0, 0, 0, 1];
Kr = [830.457114,	0.0,	640, 0;	
    0,	830.457114,	384, 0;
    0,	0,	1, 0;
    0, 0, 0, 1];
Kv = [830.457114,	0,	640, 0;	
    0,	830.457114,	384, 0;	
    0,	0,	1, 0;
    0, 0, 0, 1];

%Macierze parametrów zewnêtrznych (rotacja + wektor kolumnowy)
RTr = [0.942641, 0.000000, -0.333807, -0.350497;
    0.000000, 1.000000, 0.000000, 0.000000;
    0.333807, 0.000000, 0.942641, -0.989774;
    0, 0, 0, 1];
RTr(1:3,4)=convertVecorT(RTr);
RTv = [0.974370, 0.000000, -0.224951, -0.236199;
      0.000000, 1.000000, 0.000000, 0.000000;
      0.224951, 0.000000, 0.974370, -1.023089;
      0, 0, 0, 1];
RTv(1:3,4)=convertVecorT(RTv);

 %Macierze projekcji
 Pr = Kr*RTr;
 Pv = Kv*RTv;
 P = Pv / Pr;
 
     %Wczytywanie sekwencji
[Y_cam01, U_cam01, V_cam01] = yuv_import(view0, [width, height],nFrame,0,'YUV420_8'); 
[Y_cam1, U_cam1, V_cam1] = yuv_import(view1, [width, height],nFrame,0,'YUV420_8'); 
[Y_cam0_depth_cell, U_cam0_depth, V_cam0_depth] = yuv_import(view0_depth,[width, height],nFrame,0,'YUV420_16');

Y_cam0 = cell2mat(Y_cam01(1));
U_cam0 = cell2mat(U_cam01(1));
V_cam0 = cell2mat(V_cam01(1));
Y_cam0_depth = cell2mat(Y_cam0_depth_cell(1));
Y_cam1 = cell2mat(Y_cam1(1));
U_cam1 = cell2mat(U_cam1(1));
V_cam1 = cell2mat(V_cam1(1));
% Obliczenie wartoœci g³ebi Zr wg wzoru 1/Zr = Z/65535 * Z'near + 1/Zfar
Znear = 0.2;
Zfar = 700;
Z_near = (1/Znear) - (1/Zfar);

Zr = zeros(height,width);

for h=1:height
   for w=1:width
        Z = double(Y_cam0_depth(h,w,1));
        Zr(h,w) = Z/65535 * Z_near + 1/Zfar;
        Zr(h,w) = (1/Zr(h,w));      
   end
end


% Synteza widoku wirtualnego kamery 1

x_v = zeros(height,width);
y_v = zeros(height,width);
z_v = zeros(height,width);


    % val = [x'; y'; z'; w']
for h=1:height
   for w=1:width
       zZ = Zr(h,w);
       zwZ = w*zZ;
       zhZ = h*zZ;
       val = P * [zwZ;zhZ;Zr(h,w);1];
       invZ = 1 / val(3);
       x_val = round(val(1) * invZ );
       y_val = round(val(2) * invZ );
       if(x_val > 0 && x_val < width && y_val > 0 && y_val < height)
           %[x_val y_val invZ]
           if(z_v(y_val,x_val) < invZ)
               x_v(h,w) = x_val;
               y_v(h,w) = y_val;
               z_v(y_val,x_val) = invZ;
           end
       end
   end
end


%Konwersja z YUV na RGB
imageRealCam0 = double(zeros(height, width, 3,nFrame));
imageRealCam1 = YUVframeToRGBframe(Y_cam1, U_cam1, V_cam1, width, height);
% imageRealCam1 = double(zeros(height, width, 3,nFrame));
imageVirtual = double(zeros(height, width, 3));

    %Obrazy rzeczywiste
for n=1:nFrame
for h=1:height/2
   for w=1:width/2
       
       %Cam 0
       U_mod = double(U_cam0(h,w,n));
       V_mod = double(V_cam0(h,w,n));
       
       i_w = (w-1)*2 + 1;
       i_h = (h-1)*2 + 1;
       Y_mod = double(Y_cam0(i_h,i_w,n));
       [r,g,b] = YUVtoRGB(Y_mod,U_mod,V_mod);
       imageRealCam0(i_h,i_w,1,n) = r;
       imageRealCam0(i_h,i_w,2,n) = g;
       imageRealCam0(i_h,i_w,3,n) = b;
       
       i_w = (w-1)*2 + 1;
       i_h = (h-1)*2 + 2;
       Y_mod = double(Y_cam0(i_h,i_w,n));
       [r,g,b] = YUVtoRGB(Y_mod,U_mod,V_mod);
       imageRealCam0(i_h,i_w,1,n) = r;
       imageRealCam0(i_h,i_w,2,n) = g;
       imageRealCam0(i_h,i_w,3,n) = b;
       
       i_w = (w-1)*2 + 2;
       i_h = (h-1)*2 + 1;
       Y_mod = double(Y_cam0(i_h,i_w,n));
       [r,g,b] = YUVtoRGB(Y_mod,U_mod,V_mod);
       imageRealCam0(i_h,i_w,1,n) = r;
       imageRealCam0(i_h,i_w,2,n) = g;
       imageRealCam0(i_h,i_w,3,n) = b;
       
       i_w = (w-1)*2 + 2;
       i_h = (h-1)*2 + 2;
       Y_mod = double(Y_cam0(i_h,i_w,n));
       [r,g,b] = YUVtoRGB(Y_mod,U_mod,V_mod);
       imageRealCam0(i_h,i_w,1,n) = r;
       imageRealCam0(i_h,i_w,2,n) = g;
       imageRealCam0(i_h,i_w,3,n) = b;
       
   end
end
end
% figure()
% subplot(2,1,1)
% imshow(uint8(imageRealCam0(:,:,:,1)))
% 
% subplot(2,1,2)
% imshow(uint8(imageRealCam1(:,:,:,1)))

% Rzutowanie kolorów na obraz wirtualny
for h=1:height
   for w=1:width
       x = x_v(h,w);
       y = y_v(h,w);
       if(x == 0 || y == 0)
       %imageVirtual(y,x,1) = 0;
       %imageVirtual(y,x,2) = 0;
       %imageVirtual(y,x,3) = 0;
       else
       imageVirtual(y,x,1) = imageRealCam0(h,w,1,1);
       imageVirtual(y,x,2) = imageRealCam0(h,w,2,1);
       imageVirtual(y,x,3) = imageRealCam0(h,w,3,1);
       end
   end
end

figure()
imshow(uint8(imageVirtual(:,:,:)))

figure()
imshow(uint8(imageRealCam0(:,:,:)))

figure()
imshow(uint8(imageRealCam1(:,:,:)))