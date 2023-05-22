clear;
clc;
close all;
% ---------------------------------------------------------%
% KAMERA 0
% Parametry wczytywanej sekewencji

width  = 1024;
height = 768;
nFrame = 1;

view0 = 'BT_1024x768_cam0.yuv';
view0_depth = 'BTd_1024x768_16bps_cf400_cam0.yuv';

%Macierze parametrów wewnêtrznych 
Kr = [1918.270000,	2.489820,	494.085000, 0;	
    0,	-1922.580000,	320.264, 0;
    0,	0,	1, 0
    0, 0, 0, 1];
Kv = [1913.690000,	-0.143610,	533.307000 0;	
    0,	-1918.170000,	369.829 0;	
    0,	0,	1 0
    0 0 0 1];

%Macierze parametrów zewnêtrznych (rotacja + wektor kolumnowy)
RTr = [0.949462,	0.046934,	0.310324,	14.770269020855228;
    -0.042337,	0.998867,	-0.021532,	0.508720535310591;
    -0.310985,	0.007308,	0.950373,	3.373782064282775;
    0 0 0 1];
RTr(1:3,4)=convertVecorT(RTr);
RTv = [0.972850,	0.010365,	0.231187,	11.511715628665055;
      -0.012981,	0.999864,	0.009794,	0.488957584989012;
      -0.231056,	-0.012528,	0.972852,	1.665662019424923
      0 0 0 1];
RTv(1:3,4)=convertVecorT(RTv);  
% Wczytywanie g³êbi
[Y_cam0_depth_cell, U_cam0_depth, V_cam0_depth] = yuv_import(view0_depth,[width, height],nFrame,8,'YUV420_16');

Y_cam0_depth = cell2mat(Y_cam0_depth_cell(1));
Y_cam0_depth = fixDepth(Y_cam0_depth,width,height,1);

%Wczytywanie i konwersja sekwencji
[Y_cam0, U_cam0, V_cam0] = yuv_import(view0,[width, height],nFrame,8,'YUV420_8');
Y_ = cell2mat(Y_cam0(1));
U_ = cell2mat(U_cam0(1));
V_ = cell2mat(V_cam0(1));

RGB_cam0 = YUVframeToRGBframe(Y_, U_, V_, width, height);


%Synteza
[synthView0, synthDepth0] = synthesizeVirtualView(RGB_cam0, Y_cam0_depth, Kr, Kv, RTr, RTv, width, height, 42, 130);

figure()
imshow(uint8(synthView0))

% ---------------------------------------------------------%
% KAMERA 2
% Parametry wczytywanej sekewencji
view2 = 'BT_1024x768_cam2.yuv';
view2_depth = 'BTd_1024x768_16bps_cf400_cam2.yuv';

%Macierze parametrów wewnêtrznych 
Kr2 = [1914.070000,	0.343703,	564.645000, 0;	
    0,	-1918.500000,	339.578, 0;
    0,	0,	1, 0;
    0, 0, 0, 1];


%Macierze parametrów zewnêtrznych (rotacja + wektor kolumnowy)
RTr2 = [0.989230,	0.003946,	0.146295,	7.902808420017240;
    -0.004391,	0.999983,	0.002724,	0.466951773779989;
    -0.146283,	-0.003337,	0.989230,	-0.237005810403560
    0 0 0 1];
RTr2(1:3,4)=convertVecorT(RTr2);
  
% Wczytywanie g³êbi
[Y_cam2_depth_cell, U_cam2_depth, V_cam2_depth] = yuv_import(view0_depth,[width, height],nFrame,8,'YUV420_16');

Y_cam2_depth = cell2mat(Y_cam2_depth_cell(1));
Y_cam2_depth = fixDepth(Y_cam2_depth,width,height,1);

%Wczytywanie i konwersja sekwencji
[Y_cam2, U_cam2, V_cam2] = yuv_import(view2,[width, height],nFrame,8,'YUV420_8');
Y_2 = cell2mat(Y_cam2(1));
U_2 = cell2mat(U_cam2(1));
V_2 = cell2mat(V_cam2(1));

RGB_cam2 = YUVframeToRGBframe(Y_2, U_2, V_2, width, height);


%Synteza
[synthView2, synthDepth2] = synthesizeVirtualView(RGB_cam2, Y_cam2_depth, Kr2, Kv, RTr2, RTv, width, height, 42, 130);

figure()
imshow(uint8(synthView2))


% ---------------------------------------------------------%
% £¥CZENIE WIDOKÓW 1.0
[mergedView1, mergedDepth1] = mergeViews(synthView0, synthDepth0, synthView2, synthDepth2, width, height);
figure()
imshow(uint8(mergedView1))
% figure()
% imshow(uint16(mergedDepth1))