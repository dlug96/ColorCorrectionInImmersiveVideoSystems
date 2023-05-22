clear; clc; close all;

% Paramtry wczytywanych sekewencji

width  = 1024;
height = 768;
nFrame = 20;

Znear = 42;
Zfar = 130;

view0 = 'BT_1024x768_cam0.yuv';
view0Depth = 'BTd_1024x768_16bps_cf400_cam0.yuv';
view1 = 'BT_1024x768_cam1.yuv';
view1Depth = 'BTd_1024x768_16bps_cf400_cam1.yuv';
view2 = 'BT_1024x768_cam2.yuv';
view2Depth = 'BTd_1024x768_16bps_cf400_cam2.yuv';
view3 = 'BT_1024x768_cam3.yuv';
view3Depth = 'BTd_1024x768_16bps_cf400_cam3.yuv';
view4 = 'BT_1024x768_cam4.yuv';
view4Depth = 'BTd_1024x768_16bps_cf400_cam4.yuv';
view5 = 'BT_1024x768_cam5.yuv';
view5Depth = 'BTd_1024x768_16bps_cf400_cam5.yuv';
view6 = 'BT_1024x768_cam6.yuv';
view6Depth = 'BTd_1024x768_16bps_cf400_cam6.yuv';
view7 = 'BT_1024x768_cam7.yuv';
view7Depth = 'BTd_1024x768_16bps_cf400_cam7.yuv';
yDepthCam0 = zeros(height,width,nFrame); 
yCam0 = zeros(height,width,nFrame); 
% yCam1 = zeros(height,width,nFrame); yCam2 = zeros(height,width,nFrame); yCam3 = zeros(nFrame,height,width); yCam4 = zeros(height,width,nFrame); yCam5 = zeros(height,width,nFrame); yCam6 = zeros(height,width,nFrame); yCam7 = zeros(height,width,nFrame);
uCam0 = zeros(height/2,width/2,nFrame); 
% uCam1 = zeros(height/2,width/2,nFrame); uCam2 = zeros(height/2,width/2,nFrame); uCam3 = zeros(height/2,width/2,nFrame); uCam4 = zeros(height/2,width/2,nFrame); uCam5 = zeros(height/2,width/2,nFrame); uCam6 = zeros(height/2,width/2,nFrame); uCam7 = zeros(height/2,width/2,nFrame);
vCam0 = zeros(height/2,width/2,nFrame); 
% vCam1 = zeros(height/2,width/2,nFrame); vCam2 = zeros(height/2,width/2,nFrame); vCam3 = zeros(height/2,width/2,nFrame); vCam4 = zeros(height/2,width/2,nFrame); vCam5 = zeros(height/2,width/2,nFrame); vCam6 = zeros(height/2,width/2,nFrame); vCam7 = zeros(height/2,width/2,nFrame);
% yDepthCam1 = zeros(height,width,nFrame); yDepthCam2 = zeros(height,width,nFrame); yDepthCam3 = zeros(height,width,nFrame); yDepthCam4 = zeros(height,width,nFrame); yDepthCam5 = zeros(height,width,nFrame); yDepthCam6 = zeros(height,width,nFrame); yDepthCam7 = zeros(height,width,nFrame);

% rgbSynthCam0 = zeros(height,width,3,nFrame); rgbSynthCam1 = zeros(height,width,3,nFrame); rgbSynthCam2 = zeros(height,width,3,nFrame); rgbSynthCam3 = zeros(height,width,nFrame); rgbSynthCam4 = zeros(height,width,3,nFrame); rgbSynthCam5 = zeros(height,width,3,nFrame); rgbSynthCam6 = zeros(height,width,nFrame); rgbSynthCam7 = zeros(height,width,3,nFrame);
% rgbSynthDepthCam0 = zeros(height,width,3,nFrame); rgbSynthDepthCam1 = zeros(height,width,3,nFrame); rgbSynthDepthCam2 = zeros(height,width,3,nFrame); rgbSynthDepthCam3 = zeros(height,width,nFrame); rgbSynthDepthCam4 = zeros(height,width,3,nFrame); rgbSynthDepthCam5 = zeros(height,width,3,nFrame); rgbSynthDepthCam6 = zeros(height,width,3,nFrame); rgbSynthDepthCam7 = zeros(height,width,3,nFrame);

%Macierze parametrów wewnêtrznych 
K0 = [1918.270000,	2.489820,	494.085000, 0;	
    0,	-1922.580000,	320.264, 0;
    0,	0,	1, 0;
    0, 0, 0, 1];
K1 = [1913.690000,	-0.143610,	533.307000, 0;	
    0,	-1918.170000,	369.829, 0;	
    0,	0,	1, 0;
    0, 0, 0, 1];
K2 = [1914.070000,	0.343703,	564.645000, 0;	
    0,	-1918.500000,	339.578, 0;
    0,	0,	1, 0;
    0, 0, 0, 1];
K3 = [1909.910000,	0.571503,	545.069000, 0;	
    0,	-1915.890000,	373.694, 0;	
    0,	0,	1, 0;
    0, 0, 0, 1];
K4 = [1908.250000,	0.335031,	560.336000, 0;	
    0,	-1914.160000,	358.404, 0;
    0,	0,	1, 0;
    0, 0, 0, 1];
K5 = [1915.780000,	1.210910,	527.609000, 0;	
    0,	-1921.730000,	373.545	, 0;	
    0,	0,	1, 0;
    0, 0, 0, 1];
K6 = [1910.570000,	0.786148,	578.134000, 0;	
    0,	-1916.270000,	363.531, 0;
    0,	0,	1, 0;
    0, 0, 0, 1];
K7 = [1929.090000,	0.831916,	585.520000, 0;	
    0,	-1937.210000,	351.056, 0;	
    0,	0,	1, 0;
    0, 0, 0, 1];

%Macierze parametrów zewnêtrznych
RT0 = [ 0.949462,	0.046934,	0.310324,	14.770269020855228;
        -0.042337,	0.998867,	-0.021532,	0.508720535310591;
        -0.310985,	0.007308,	0.950373,	3.373782064282775;
        0, 0, 0, 1];
RT0(1:3,4)=convertVecorT(RT0);
RT1 = [ 0.972850,	0.010365,	0.231187,	11.511715628665055;
        -0.012981,	0.999864,	0.009794,	0.488957584989012;
        -0.231056,	-0.012528,	0.972852,	1.665662019424923;
        0, 0, 0, 1];
RT1(1:3,4)=convertVecorT(RT1);
RT2 = [ 0.989230,	0.003946,	0.146295,	7.902808420017240;
        -0.004391,	0.999983,	0.002724,	0.466951773779989;
        -0.146283,	-0.003337,	0.989230,	-0.237005810403560;
        0, 0, 0, 1];
RT2(1:3,4)=convertVecorT(RT2);
RT3 = [ 0.996415,	0.026023,	0.080480,	3.902173087726401;
        -0.026884,	0.999591,	0.009614,	0.143986185718271;
        -0.080197,	-0.011743,	0.996707,	0.146424581040651;
        0, 0, 0, 1];
RT3(1:3,4)=convertVecorT(RT3);
RT4 = [ 1.000000	0.000000	0.000000	0.000002;
        0.000000	1.000000	-0.000000	-0.000006;
        0.000000	-0.000000	1.000000	0.000000;
        0, 0, 0, 1];
RT4(1:3,4)=convertVecorT(RT4);
RT5 = [0.998175	0.028914	-0.053000	-3.864462904792078;
      -0.012981,	0.999864,	0.009794,	0.488957584989012;
      -0.231056,	-0.012528,	0.972852,	1.665662019424923;
      0, 0, 0, 1];
RT5(1:3,4)=convertVecorT(RT5);  
RT6 = [ 0.988494,	0.037674,	-0.146458,	-7.510047121873114;
        -0.037105,	0.999288,	0.006622,	-0.240922680890810;
        0.146603,	-0.001111,	0.989188,	1.158085998929925;
        0, 0, 0, 1];
RT6(1:3,4)=convertVecorT(RT6);
RT7 = [ 0.975422,	0.032363,	-0.217910,	-10.811550889156614;
        -0.033721,	0.999425,	-0.002516,	-0.558877549888208;
        0.217705,	0.009803,	0.975952,	2.653065276719957;
        0, 0, 0, 1];
RT7(1:3,4)=convertVecorT(RT7);



[yCellCam0, uCellCam0, vCellCam0] = yuv_import(view0, [width, height],nFrame,0,'YUV420_8');
[yCellDepthCam0, uCellDepthCam0, vCellDepthCam0] = yuv_import(view0Depth, [width, height],nFrame,0,'YUV420_16'); 
% [yCellCam1, uCellCam1, vCellCam1] = yuv_import(view1, [width, height],nFrame,0,'YUV420_8');
% [yCellDepthCam1, uCellDepthCam1, vCellDepthCam1] = yuv_import(view1Depth, [width, height],nFrame,0,'YUV420_16'); 
% [yCellCam2, uCellCam2, vCellCam2] = yuv_import(view2, [width, height],nFrame,0,'YUV420_8'); 
% [yCellDepthCam2, uCellDepthCam2, vCellDepthCam2] = yuv_import(view2Depth, [width, height],nFrame,0,'YUV420_16');
% [yCellCam3, uCellCam3, vCellCam3] = yuv_import(view3, [width, height],nFrame,0,'YUV420_8'); 
% [yCellDepthCam3, uCellDepthCam3, vCellDepthCam3] = yuv_import(view3Depth, [width, height],nFrame,0,'YUV420_16');
% [yCellCam4, uCellCam4, vCellCam4] = yuv_import(view4, [width, height],nFrame,0,'YUV420_8'); 
% [yCellDepthCam4, uCellDepthCam4, vCellDepthCam4] = yuv_import(view4Depth, [width, height],nFrame,0,'YUV420_16');
% [yCellCam5, uCellCam5, vCellCam5] = yuv_import(view5, [width, height],nFrame,0,'YUV420_8'); 
% [yCellDepthCam5, uCellDepthCam5, vCellDepthCam5] = yuv_import(view5Depth, [width, height],nFrame,0,'YUV420_16');
% [yCellCam6, uCellCam6, vCellCam6] = yuv_import(view6, [width, height],nFrame,0,'YUV420_8'); 
% [yCellDepthCam6, uCellDepthCam6, vCellDepthCam6] = yuv_import(view6Depth, [width, height],nFrame,0,'YUV420_16');
% [yCellCam7, uCellCam7, vCellCam7] = yuv_import(view7, [width, height],nFrame,0,'YUV420_8'); 
% [yCellDepthCam7, uCellDepthCam7, vCellDepthCam7] = yuv_import(view7Depth, [width, height],nFrame,0,'YUV420_16');
% 

for n=1:nFrame
   yCam0(:,:,n) = cell2mat(yCellCam0(n)); uCam0(:,:,n) = cell2mat(uCellCam0(n)); vCam0(:,:,n) = cell2mat(vCellCam0(n));
   yDepthCam0(:,:,n) = cell2mat(yCellDepthCam0(n));
%    yCam1(:,:,n) = cell2mat(yCellCam1(n)); uCam1(:,:,n) = cell2mat(uCellCam1(n)); vCam1(:,:,n) = cell2mat(vCellCam1(n));
%    yDepthCam1(n,:,:) = cell2mat(yCellDepthCam1(n));
%    yCam2(n,:,:) = cell2mat(yCellCam2(n)); uCam2(n,:,:) = cell2mat(uCellCam2(n)); vCam2(:,:,n) = cell2mat(vCellCam2(n));
%    yDepthCam2(n,:,:) = cell2mat(yCellDepthCam2(n));
%    yCam3(n,:,:) = cell2mat(yCellCam3(n)); uCam3(n,:,:) = cell2mat(uCellCam3(n)); vCam3(:,:,n) = cell2mat(vCellCam3(n));
%    yDepthCam3(n,:,:) = cell2mat(yCellDepthCam3(n));
%    yCam4(n,:,:) = cell2mat(yCellCam4(n)); uCam4(n,:,:) = cell2mat(uCellCam4(n)); vCam4(:,:,n) = cell2mat(vCellCam4(n));
%    yDepthCam4(n,:,:) = cell2mat(yCellDepthCam4(n));
%    yCam5(n,:,:) = cell2mat(yCellCam5(n)); uCam5(n,:,:) = cell2mat(uCellCam5(n)); vCam5(:,:,n) = cell2mat(vCellCam5(n));
%    yDepthCam5(n,:,:) = cell2mat(yCellDepthCam5(n));
%    yCam6(n,:,:) = cell2mat(yCellCam6(n)); uCam6(n,:,:) = cell2mat(uCellCam6(n)); vCam6(n,:,:) = cell2mat(vCellCam6(n));
%    yDepthCam6(n,:,:) = cell2mat(yCellDepthCam6(n));
%    yCam7(n,:,:) = cell2mat(yCellCam7(n)); uCam7(n,:,:) = cell2mat(uCellCam7(n)); vCam7(n,:,:) = cell2mat(vCellCam7(n));
%    yDepthCam7(n,:,:) = cell2mat(yCellDepthCam7(n));
end

%   Fixing depth
    yDepthCam0 = fixDepth(yDepthCam0,width, height,nFrame);
    imageY = zeros(height,width,nFrame);
    imageU = zeros(height/2,width/2,nFrame);
    imageV = zeros(height/2,width/2,nFrame);
    Y_ = cell(nFrame);
    U_ = cell(nFrame);
    V_ = cell(nFrame);
    outView= zeros(height,width,3);
    outDepth= zeros(height,width);
    rgb1 = zeros(height,width,3,nFrame);
for frame = 1:nFrame
    imageView = YUVframeToRGBframe(yCam0(:,:,frame),uCam0(:,:,frame),vCam0(:,:,frame),width,height);
    [outView,outDepth] = synthesizeVirtualView(imageView, yDepthCam0(:,:,frame), K0, K1, RT0, RT1, width, height, Znear, Zfar);
    rgb1(:,:,:,frame)=outView;
    [imageY, imageU, imageV] = RGBframeToYUVframe(outView,width,height);
    Y_(frame) = mat2cell(imageY,height,width);
    U_(frame) = mat2cell(imageU,height/2,width/2);
    V_(frame) = mat2cell(imageV,height/2,width/2);
end
yuv_export(Y_,U_,V_,'aBTtest_1024x768.yuv',nFrame);
figure()
imshow(uint8(rgb1(:,:,:,10)))
