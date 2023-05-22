clear; clc; close all;

% Paramtry wczytywanych sekewencji

width  = 1024;
height = 768;
nFrame = 1;

view0 = 'BT_1024x768_cam2.yuv';
view0_depth = 'BTd_1024x768_16bps_cf400_cam2.yuv';
view1 = 'BT_1024x768_cam1.yuv';
% view1_depth = 'BTd_1024x768_16bps_cf400_cam1.yuv';

% Parametry kamer (r - rzeczywista, v - wirtualna)

%Macierze parametrów wewnêtrznych 
Kr = [1918.270000,	2.489820,	494.085000, 0;	
    0,	-1922.580000,	320.264, 0;
    0,	0,	1, 0;
    0, 0, 0, 1];
Kv = [1913.690000,	-0.143610,	533.307000, 0;	
    0,	-1918.170000,	369.829, 0;	
    0,	0,	1, 0;
    0, 0, 0, 1];

%Macierze parametrów zewnêtrznych (rotacja + wektor kolumnowy)
RTr = [0.989230,	0.003946,	0.146295,	7.902808420017240;
	0.004391,	0.999983,	0.002724,	0.466951773779989;
    -0.146283,	-0.003337,	0.989230,	-0.237005810403560;
    0, 0, 0, 1];
RTr(1:3,4)=convertVecorT(RTr);
RTv = [0.972850,	0.010365,	0.231187,	11.511715628665055;
      -0.012981,	0.999864,	0.009794,	0.488957584989012;
      -0.231056,	-0.012528,	0.972852,	1.665662019424923;
      0, 0, 0, 1];
RTv(1:3,4)=convertVecorT(RTv);

 %Macierze projekcji
 Pr = Kr*RTr;
 Pv = Kv*RTv;
 P = Pv / Pr;
 
     %Wczytywanie sekwencji
[Y_cam01, U_cam01, V_cam01] = yuv_import(view0, [1024, 768],nFrame,0,'YUV420_8'); 
[Y_cam11, U_cam11, V_cam11] = yuv_import(view1, [1024, 768],nFrame,0,'YUV420_8'); 
[Y_cam0_depth_cell, U_cam0_depth, V_cam0_depth] = yuv_import(view0_depth,[1024, 768],nFrame,0,'YUV420_16');

Y_cam0 = cell2mat(Y_cam01(1));
U_cam0 = cell2mat(U_cam01(1));
V_cam0 = cell2mat(V_cam01(1));
Y_cam0_depth = cell2mat(Y_cam0_depth_cell(1));

Y_cam1 = cell2mat(Y_cam11(1));
U_cam1 = cell2mat(U_cam11(1));
V_cam1 = cell2mat(V_cam11(1));

% Obliczenie wartoœci g³ebi Zr wg wzoru 1/Zr = Z/65535 * Z'near + 1/Zfar
Znear = 42;
Zfar = 130;
Z_near = (1/Znear) - (1/Zfar);

Zr = zeros(768,1024);

for h=1:height
   for w=1:width
        Z = double(Y_cam0_depth(h,w,1));
        Zr(h,w) = Z/65535 * Z_near + 1/Zfar;
        Zr(h,w) = (1/Zr(h,w));      
   end
end


% Synteza widoku wirtualnego kamery 1

x_v = zeros(768,1024);
y_v = zeros(768,1024);
z_v = zeros(768,1024);


    % val = [x'; y'; z'; w']
for h=1:height
   for w=1:width
       val = P * [w*Zr(h,w);h*Zr(h,w);Zr(h,w);1];
       invZ = 1 / val(3);
       x_val = round(val(1) * invZ);
       y_val = round(val(2) * invZ);
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
imageRealCam0 = YUVframeToRGBframe(Y_cam0, U_cam0, V_cam0, width, height);
imageRealCam1 = YUVframeToRGBframe(Y_cam1, U_cam1, V_cam1, width, height);
% imageRealCam1 = double(zeros(height, width, 3,nFrame));
imageVirtual = double(zeros(height, width, 3));


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
       imageVirtual(y,x,1) = imageRealCam0(h,w,1);
       imageVirtual(y,x,2) = imageRealCam0(h,w,2);
       imageVirtual(y,x,3) = imageRealCam0(h,w,3);
       end
   end
end

figure()
imshow(uint8(imageVirtual(:,:,:)))



figure()
imshow(uint8(imageRealCam1(:,:,:)))
