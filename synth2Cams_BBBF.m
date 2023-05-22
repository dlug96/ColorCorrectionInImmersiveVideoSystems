clear;
clc;
close all;
% ---------------------------------------------------------%
% KAMERA 0
% Parametry wczytywanej sekewencji

width  = 1280;
height = 768;
nFrame = 1;

view0 = 'BBBF_1280x768_cam06.yuv';
view0_depth = 'BBBFd_1280x768_16bps_cf400_cam06.yuv';
view1 = 'BBBF_1280x768_cam19.yuv';

%Macierze parametrów wewnêtrznych 
Kr = [830.457114, 0.000000, 640.000000, 0;	
    0.000000, 830.457114, 384.000000, 0;
    0,	0,	1, 0;
    0, 0, 0, 1];
Kv = [830.457114, 0.000000, 640.000000, 0;	
    0.000000, 830.457114, 384.000000, 0;	
    0,	0,	1, 0;
    0, 0, 0, 1];

%Macierze parametrów zewnêtrznych (rotacja + wektor kolumnowy)
RTr = [0.942641, 0.000000, -0.333807, -0.350497;
    0.000000, 1.000000, 0.000000, 0.000000;
    0.333807, 0.000000, 0.942641, -0.989774;
    0, 0, 0, 1];
RTv = [0.974370, 0.000000, -0.224951, -0.236199;
      0.000000, 1.000000, 0.000000, 0.000000;
      0.224951, 0.000000, 0.974370, -1.023089;
      0, 0, 0, 1];
  
% Wczytywanie g³êbi
[Y_cam0_depth_cell, U_cam0_depth, V_cam0_depth] = yuv_import(view0_depth,[width, height],nFrame,0,'YUV420_16');

Y_cam0_depth = cell2mat(Y_cam0_depth_cell(1));

%Wczytywanie i konwersja sekwencji
[Y_cam0, U_cam0, V_cam0] = yuv_import(view0,[width, height],nFrame,0,'YUV420_8');
Y_ = cell2mat(Y_cam0(1));
U_ = cell2mat(U_cam0(1));
V_ = cell2mat(V_cam0(1));

RGB_cam0 = YUVframeToRGBframe(Y_, U_, V_, width, height);


%Synteza
[synthView0, synthDepth0] = synthesizeVirtualView(RGB_cam0, Y_cam0_depth, Kr, Kv, RTr, RTv, width, height, 0.2, 700);

figure()
imshow(uint8(synthView0))

% ---------------------------------------------------------%
% KAMERA 2
% Parametry wczytywanej sekewencji
view2 = 'BBBF_1280x768_cam32.yuv';
view2_depth = 'BBBFd_1280x768_16bps_cf400_cam32.yuv';

%Macierze parametrów wewnêtrznych 
Kr2 = [830.457114, 0.000000, 640.000000, 0;	
    0.000000, 830.457114, 384.000000, 0;
    0,	0,	1, 0;
    0, 0, 0, 1];


%Macierze parametrów zewnêtrznych (rotacja + wektor kolumnowy)
RTr2 = [0.993572, 0.000000, -0.113203, -0.118863;
    0.000000, 1.000000, 0.000000, 0.000000;
    0.113203, 0.000000, 0.993572, -1.043250;
    0, 0, 0, 1];

  
% Wczytywanie g³êbi
[Y_cam2_depth_cell, U_cam2_depth, V_cam2_depth] = yuv_import(view0_depth,[width, height],nFrame,0,'YUV420_16');

Y_cam2_depth = cell2mat(Y_cam0_depth_cell(1));

%Wczytywanie i konwersja sekwencji
[Y_cam2, U_cam2, V_cam2] = yuv_import(view2,[width, height],nFrame,0,'YUV420_8');
Y_2 = cell2mat(Y_cam2(1));
U_2 = cell2mat(U_cam2(1));
V_2 = cell2mat(V_cam2(1));

RGB_cam2 = YUVframeToRGBframe(Y_2, U_2, V_2, width, height);


%Synteza
[synthView2, synthDepth2] = synthesizeVirtualView(RGB_cam2, Y_cam2_depth, Kr2, Kv, RTr2, RTv, width, height,0.2,700);

figure()
imshow(uint8(synthView2))


% ---------------------------------------------------------%
% £¥CZENIE WIDOKÓW 1.0
[mergedView1, mergedDepth1] = mergeViews(synthView0, synthDepth0, synthView2, synthDepth2, width, height);
figure()
imshow(uint8(mergedView1))
% figure()
% imshow(uint16(mergedDepth1))