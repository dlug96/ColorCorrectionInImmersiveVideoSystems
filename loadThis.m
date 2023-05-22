clear; clc; close all;

% Wczytywanie sekwencji
videoSequence = 'BT_1024x768_cam0.yuv';
width  = 1024;
height = 768;
nFrame = 10;

[Y_,U_,V_] = yuv_import(videoSequence, [width, height], nFrame);
Y_mat = uint8(zeros(height, width, nFrame));
U_mat = uint8(zeros(height/2, width/2, nFrame));
V_mat = uint8(zeros(height/2, width/2, nFrame));

image = uint8(zeros(height, width, 3, nFrame));

% Konwersja do RGB
for n = 1:nFrame
    Z = uint8(cell2mat(Y_(n)));
    Y_mat(:,:,n) = Z;
    
    Z = uint8(cell2mat(U_(n)));
    U_mat(:,:,n) = Z;
    
    Z = uint8(cell2mat(V_(n)));
    V_mat(:,:,n) = Z;
    
    image(:,:,:,n) = YUVframeToRGBframe(Y_mat(:,:,n), U_mat(:,:,n), V_mat(:,:,n), width, height);
end

figure()
imshow(image(:,:,:,10))
