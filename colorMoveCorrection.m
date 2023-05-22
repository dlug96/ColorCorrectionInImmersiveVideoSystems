function [modifiedImage] = colorMoveCorrection(changedImage, referenceImageSyn, referenceImageReal, depthRef, depthSyn, width, height)
%colorMoveCorrection Korekcja koloru z wykorzystaniem algorytmu
%przeniesienia koloru


mainImage = referenceImageSyn;
referenceImage = referenceImageReal;
d2 = depthSyn;
d1 = depthRef;

%Zmiana z przestrzeni RGB na l_alpha_beta
labMainImage = rgb2lab((mainImage));
labRefImage = rgb2lab((referenceImage));
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

labChangedImage(:,:,1) = (labChangedImage(:,:,1) - meanMainL) * (standardDevMainL/standardDevRefL) + meanRefL;
labChangedImage(:,:,2) = (labChangedImage(:,:,2) - meanMainA) * (standardDevMainA/standardDevRefA) + meanRefA;
labChangedImage(:,:,3) = (labChangedImage(:,:,3) - meanMainB) * (standardDevMainB/standardDevRefB) + meanRefB;

newImage = lab2rgb(labChangedImage,'OutputType','uint8');
modifiedImage = newImage;
end