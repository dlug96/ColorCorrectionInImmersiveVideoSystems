clear;
clc;
close all;

% Paramtry wczytywanych sekewencji

width  = 1024;
height = 768;
nFrame = 1;

view0 = 'BT_1024x768_cam0.yuv';
view0_depth = 'BTd_1024x768_16bps_cf400_cam0.yuv';

%Macierze parametrów wewnêtrznych 
Kr = [1918.270000,	2.489820,	494.085000 0;	
    0,	-1922.580000,	320.264 0;
    0,	0,	1 0
    0 0 0 1];
Kv = [1913.690000,	-0.143610,	533.307000 0;	
    0,	-1918.170000,	369.829 0;	
    0,	0,	1 0
    0 0 0 1];

%Macierze parametrów zewnêtrznych (rotacja + wektor kolumnowy)
RTr = [0.949462,	0.046934,	0.310324,	14.770269020855228;
    -0.042337,	0.998867,	-0.021532,	0.508720535310591;
    -0.310985,	0.007308,	0.950373,	3.373782064282775
    0 0 0 1];
RTv = [0.972850,	0.010365,	0.231187,	11.511715628665055;
      -0.012981,	0.999864,	0.009794,	0.488957584989012;
      -0.231056,	-0.012528,	0.972852,	1.665662019424923
      0 0 0 1];
  
% Wczytywanie g³êbi
[Y_cam0_depth_cell, U_cam0_depth, V_cam0_depth] = yuv_import(view0_depth,[width, height],nFrame,0,'YUV420_16');

Y_cam0_depth = cell2mat(Y_cam0_depth_cell(1));

%Wczytywanie i konwersja sekwencji
[Y_cam0, U_cam0, V_cam0] = yuv_import(view0,[width, height],nFrame,0,'YUV420_8');
Y_ = cell2mat(Y_cam0(1));
U_ = cell2mat(U_cam0(1));
V_ = cell2mat(V_cam0(1));

RGB_cam0 = YUVframeToRGBframe(Y_, U_, V_, width, height);

figure()
imshow(RGB_cam0)

%Synteza
[synthView, synthDepth] = synthesizeVirtualView(RGB_cam0, Y_cam0_depth, Kr, Kv, RTr, RTv, width, height);

% Zapis do pliku
% [Y, U, V] = RGBframeToYUVframe(synthView,width,height);
% Ycell = mat2cell(Y,height,width);
% Ucell = mat2cell(U,(height/2), (width/2));
% Vcell = mat2cell(V,(height/2), (width/2));
% yuv_export(Ycell, Ucell, Vcell,'synthView_1024x768.yuv',1);
% 
% Ydcell = mat2cell(uint16(synthDepth),height,width);
% UVd = zeros((height/2), (width/2));
% UVdCell = mat2cell(UVd,(height/2), (width/2));
% yuv_export(Ydcell, UVdCell, UVdCell,'synthDepth_1024x768_16bps_cf400.yuv',1);

%Korekcja - histogram
view1 = 'BT_1024x768_cam1.yuv';
view1_depth = 'BTd_1024x768_16bps_cf400_cam1.yuv';
[Y_cam1_depth_cell, U_cam1_depth, V_cam1_depth] = yuv_import(view1_depth,[width, height],nFrame,0,'YUV420_16');
[Y_cam1, U_cam1, V_cam1] = yuv_import(view1,[width, height],nFrame,0,'YUV420_8');
Y_cam1_depth = cell2mat(Y_cam1_depth_cell(1));
Y_1 = cell2mat(Y_cam1(1));
U_1 = cell2mat(U_cam1(1));
V_1 = cell2mat(V_cam1(1));

RGB_cam1 = YUVframeToRGBframe(Y_1, U_1, V_1, width, height);



% correctedHist = histogramCorrection(RGB_cam0, synthView, RGB_cam1, Y_cam1_depth, synthDepth, 1024, 768);
% figure()
% imshow(correctedHist)
% 
% 
% %Korekcja - liniowy
% correctedLinear = linearCorrection(RGB_cam0, synthView, RGB_cam1, Y_cam1_depth, synthDepth, 1024, 768);
% figure()
% imshow(uint8(correctedLinear))

% Korekcja - przeniesienie koloru
correctedMove = colorMoveCorrection(RGB_cam0, synthView, RGB_cam1, Y_cam1_depth, synthDepth, 1024, 768);
figure()
imshow(correctedMove)