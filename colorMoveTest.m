

width = 1024;
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




mainS = '_synthView_1024x768.yuv';
[Y_Scell, U_Scell, V_Scell] = yuv_import(mainS,[width, height],1,0,'YUV420_8');
Y_S = cell2mat(Y_Scell(1));
U_S = cell2mat(U_Scell(1));
V_S = cell2mat(V_Scell(1));
mainImage = YUVframeToRGBframe(Y_S, U_S, V_S, width, height);

ref = 'BT_1024x768_cam1.yuv';
[Y_Rcell, U_Rcell, V_Rcell] = yuv_import(ref,[width, height],1,0,'YUV420_8');
Y_R = cell2mat(Y_Rcell(1));
U_R = cell2mat(U_Rcell(1));
V_R = cell2mat(V_Rcell(1));
referenceImage = YUVframeToRGBframe(Y_R, U_R, V_R, width, height);

changed = 'BT_1024x768_cam0.yuv';
[Y_Ccell, U_Ccell, V_Ccell] = yuv_import(changed,[width, height],1,0,'YUV420_8');
Y_C = cell2mat(Y_Ccell(1));
U_C = cell2mat(U_Ccell(1));
V_C = cell2mat(V_Ccell(1));
changedImage = YUVframeToRGBframe(Y_C, U_C, V_C, width, height);

depthRef = 'BTd_1024x768_16bps_cf400_cam1.yuv';
[Y_dRcell, U_dRcell, V_dRcell] = yuv_import(depthRef,[width, height],1,0,'YUV420_16');
Y_dR = cell2mat(Y_dRcell(1));
U_dR = cell2mat(U_dRcell(1));
V_dR = cell2mat(V_dRcell(1));
d2 = Y_dR;


%Synteza
[synthView, synthDepth] = synthesizeVirtualView(RGB_cam0, Y_cam0_depth, Kr, Kv, RTr, RTv, width, height);
d1 = double(synthDepth);

%Zmiana z przestrzeni RGB na l_alpha_beta
labMainImage = rgb2lab(synthView);
labRefImage = rgb2lab(referenceImage);
labChangedImage = rgb2lab(changedImage);

%Obliczenie œredniej i odchylenia standardowego dla ka¿dej sk³adowej w
%obu obrazach

matrixMainL = zeros(1,width*height);
matrixMainA = zeros(1,width*height);
matrixMainB = zeros(1,width*height);

matrixRefL = zeros(1,width*height);
matrixRefA = zeros(1,width*height);
matrixRefB = zeros(1,width*height);
N = 0;

for w=1:width
    for h=1:height
        if(depthCheck(d1(h,w),d2(h,w))==1)
            N = N+1;
            matrixMainL(N) = labMainImage(h,w,1);
            matrixMainA(N) = labMainImage(h,w,2);
            matrixMainB(N) = labMainImage(h,w,3);

            matrixRefL(N) = labRefImage(h,w,1);
            matrixRefA(N) = labRefImage(h,w,2);
            matrixRefB(N) = labRefImage(h,w,3);
        end
    end
end

arrayMainL = matrixMainL(1:N);
arrayMainA = matrixMainA(1:N);
arrayMainB = matrixMainB(1:N);

arrayRefL = matrixRefL(1:N);
arrayRefA = matrixRefA(1:N);
arrayRefB = matrixRefB(1:N);
% Obraz zniekszta³cony
meanMainL = mean(arrayMainL)
standardDevMainL = std(arrayMainL)

meanMainA = mean(arrayMainA)
standardDevMainA = std(arrayMainA)

meanMainB = mean(arrayMainB)
standardDevMainB = std(arrayMainB)
% Obraz odniesienia
meanRefL = mean(arrayRefL)
standardDevRefL = std(arrayRefL)

meanRefA = mean(arrayRefA)
standardDevRefA = std(arrayRefA)

meanRefB = mean(arrayRefB)
standardDevRefB = std(arrayRefB)
% Uzyskanie obrazu zniekszta³conego


% for i=1:width
%    for j=1:height
%        lz = labMainImage(i,j,1);
%        labMainImage(i,j,1) = (lz - meanMainL) * (standardDevMainL/standardDevRefL) + meanRefL;
%        az = labMainImage(i,j,2);
%        labMainImage(i,j,2) = (az - meanMainA) * (standardDevMainA/standardDevRefA) + meanRefA;
%        bz = labMainImage(i,j,3);
%        labMainImage(i,j,3) = (bz - meanMainB) * (standardDevMainB/standardDevRefB) + meanRefB;
%    end
% end



labChangedImage(:,:,1) = (labChangedImage(:,:,1) - meanMainL) * (standardDevMainL/standardDevRefL) + meanRefL;
labChangedImage(:,:,2) = (labChangedImage(:,:,2) - meanMainA) * (standardDevMainA/standardDevRefA) + meanRefA;
labChangedImage(:,:,3) = (labChangedImage(:,:,3) - meanMainB) * (standardDevMainB/standardDevRefB) + meanRefB;

% l_alpha_beta -> RGB + wyœwietlenie
newImage = lab2rgb(labChangedImage,'OutputType','uint8');
figure()
imshow(newImage);

histRed = zeros(1,256);
histGreen = zeros(1,256);
histBlue = zeros(1,256);

histRedNew = zeros(1,256);
histGreenNew = zeros(1,256);
histBlueNew = zeros(1,256);

%Tworzenie histogramu
for c=0:255
    for w=1:height
        for h=1:width
            %Original image
            if(changedImage(w,h,1)==c)
                histRed(c+1)=histRed(c+1)+1;
            end
            if(changedImage(w,h,2)==c)
                histGreen(c+1)=histGreen(c+1)+1;
            end
            if(changedImage(w,h,3)==c)
                histBlue(c+1)=histBlue(c+1)+1;
            end
            
            %Reference image
            if(newImage(w,h,1)==c)
                histRedNew(c+1)=histRedNew(c+1)+1;
            end
            if(newImage(w,h,2)==c)
                histGreenNew(c+1)=histGreenNew(c+1)+1;
            end
            if(newImage(w,h,3)==c)
                histBlueNew(c+1)=histBlueNew(c+1)+1;
            end
            
        end
    end
    %Normalization
    histRed(c+1)=histRed(c+1)/(width+height);
    histGreen(c+1)=histGreen(c+1)/(width+height);
    histBlue(c+1)=histBlue(c+1)/(width+height);
    
    histRedNew(c+1)=histRedNew(c+1)/(width+height);
    histGreenNew(c+1)=histGreenNew(c+1)/(width+height);
    histBlueNew(c+1)=histBlueNew(c+1)/(width+height);
    
end

%Wyœwietlanie histogramów
figure()
grid('on')
subplot(3,1,1)
bar(histRed,'r');
title('Widok oryginalny (czerwony)');

subplot(3,1,2)
bar(histGreen,'g');
title('Widok oryginalny (zielony)');

subplot(3,1,3)
bar(histBlue,'b');
title('Widok oryginalny (niebieski)');

figure()
grid('on')
subplot(3,1,1)
bar(histRedNew,'r');
title('Widok skorygowany (czerwony)');

subplot(3,1,2)
bar(histGreenNew,'g');
title('Widok skorygowany (zielony)');

subplot(3,1,3)
bar(histBlueNew,'b');
title('Widok skorygowany (niebieski)');