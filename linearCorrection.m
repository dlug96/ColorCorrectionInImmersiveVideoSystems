function [modifiedImage] = linearCorrection(changedImage, referenceImageSyn, referenceImageReal, depthRef, depthSyn, width, height)
%LinearCorrection Korekcja koloru z wykorzystaniem algorytmu liniowego
%  
mainImage = referenceImageSyn;
referenceImage = referenceImageReal;


histChangedRed = zeros(1,256);
histChangedGreen = zeros(1,256);
histChangedBlue = zeros(1,256);

histRedRef = zeros(1,256);
histGreenRef = zeros(1,256);
histBlueRef = zeros(1,256);

d1 = depthRef;
d2 = depthSyn;
N = 0;
for c=0:255
    for w=1:width
        for h=1:height
            if(depthCheck(d1(h,w),d2(h,w))==1)
                N = N + 1;
                if(mainImage(h,w,1)==c)
                    histChangedRed(c+1)=histChangedRed(c+1)+1;
                end
                if(mainImage(h,w,2)==c)
                    histChangedGreen(c+1)=histChangedGreen(c+1)+1;
                end
                if(mainImage(h,w,3)==c)
                    histChangedBlue(c+1)=histChangedBlue(c+1)+1;
                end
            
            
                if(referenceImage(h,w,1)==c)
                    histRedRef(c+1)=histRedRef(c+1)+1;
                end
                if(referenceImage(h,w,2)==c)
                    histGreenRef(c+1)=histGreenRef(c+1)+1;
                end
                if(referenceImage(h,w,3)==c)
                    histBlueRef(c+1)=histBlueRef(c+1)+1;
                end
            end
        end
    end
    
end

N
% Obliczenie parametru korekcji
sumChangedHistRed = 0;
sumChangedHistBlue = 0;
sumChangedHistGreen = 0;
sumRefHistRed = 0;
sumRefHistBlue = 0;
sumRefHistGreen = 0;

for v=1:256
    sumChangedHistRed = sumChangedHistRed + histChangedRed(v)*v;
    sumChangedHistGreen = sumChangedHistGreen + histChangedGreen(v)*v;
    sumChangedHistBlue = sumChangedHistBlue + histChangedBlue(v)*v;
    
    sumRefHistRed = sumRefHistRed + histRedRef(v)*v;
    sumRefHistGreen = sumRefHistGreen + histGreenRef(v)*v;
    sumRefHistBlue = sumRefHistBlue + histBlueRef(v)*v;
end

correctionRed = sumChangedHistRed/sumRefHistRed;
correctionGreen = sumChangedHistGreen/sumRefHistGreen;
correctionBlue = sumChangedHistBlue/sumRefHistBlue;

% Przetwarzanie obrazu
newImage = double(changedImage);
newImage(:,:,1) = newImage(:,:,1)*correctionRed;
newImage(:,:,2) = newImage(:,:,2)*correctionGreen;
newImage(:,:,3) = newImage(:,:,3)*correctionBlue;

modifiedImage = newImage;

end

