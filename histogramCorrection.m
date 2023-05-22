function [modifiedImage] = histogramCorrection(changedImage, referenceImageSyn, referenceImageReal, depthRef, depthSyn, width, height)
%Histogram color correction

histRed = zeros(1,256);
histGreen = zeros(1,256);
histBlue = zeros(1,256);

histRedRef = zeros(1,256);
histGreenRef = zeros(1,256);
histBlueRef = zeros(1,256);

d1 = depthRef;
d2 = depthSyn;

% diffCheck sprawdza czy ró¿nica miêdzy porównywanyi punktami mieœci siê 
% w zakresie
N = 0;

%Tworzenie histogramu
for c=0:255
    for w=1:width
        for h=1:height
            
            if(depthCheck(d1(h,w),d2(h,w))==1)
                N = N + 1;
                %Obraz modyfikowany
                if(referenceImageSyn(h,w,1)==c)
                    histRed(c+1)=histRed(c+1)+1;
                end
                if(referenceImageSyn(h,w,2)==c)
                    histGreen(c+1)=histGreen(c+1)+1;
                end
                if(referenceImageSyn(h,w,3)==c)
                    histBlue(c+1)=histBlue(c+1)+1;
                end
            
                %Obraz odniesienia
                if(referenceImageReal(h,w,1)==c)
                    histRedRef(c+1)=histRedRef(c+1)+1;
                end
                if(referenceImageReal(h,w,2)==c)
                    histGreenRef(c+1)=histGreenRef(c+1)+1;
                end
                if(referenceImageReal(h,w,3)==c)
                    histBlueRef(c+1)=histBlueRef(c+1)+1;
                end
            end
        end
    end
    N = width + height;
    %Normalizacja histogramów
    histRed(c+1)=histRed(c+1)/ N;
    histGreen(c+1)=histGreen(c+1)/ N;
    histBlue(c+1)=histBlue(c+1)/ N;
    
    histRedRef(c+1)=histRedRef(c+1)/ N;
    histGreenRef(c+1)=histGreenRef(c+1)/ N;
    histBlueRef(c+1)=histBlueRef(c+1)/ N;
    
end

%Wyznaczanie histogramów skumulowanych
Cr_red = zeros(1,256);
Cr_blue = zeros(1,256);
Cr_green = zeros(1,256);

sum_r = 0;
sum_g = 0;
sum_b = 0;

for v=1:256
    for i=1:v
        sum_r = sum_r+histRed(i);
        sum_g = sum_g+histGreen(i);
        sum_b = sum_b+histBlue(i);
    end
    Cr_red(v) = sum_r;
    Cr_green(v) = sum_g;
    Cr_blue(v) = sum_b;
    sum_r = 0;
    sum_g = 0;
    sum_b = 0;
end

Cd_red = zeros(1,256);
Cd_blue = zeros(1,256);
Cd_green = zeros(1,256);

sum_r = 0;
sum_g = 0;
sum_b = 0;

for v=1:256
    for i=1:v
        sum_r = sum_r+histRedRef(i);
        sum_g = sum_g+histGreenRef(i);
        sum_b = sum_b+histBlueRef(i);
    end
    Cd_red(v) = sum_r;
    Cd_green(v) = sum_g;
    Cd_blue(v) = sum_b;
    sum_r = 0;
    sum_g = 0;
    sum_b = 0;
end

%Obliczanie funkcji M
M_r = zeros(1,256);
M_g = zeros(1,256);
M_b = zeros(1,256);

for v=1:256
   for u=1:256
       if(Cd_red(v) >=Cr_red(u))
          if(u==256)
              M_r(v)=u;
              break;
          end
          if(Cd_red(v)<Cr_red(u+1))
              M_r(v)=u;
              break;
          end
       end
   end
   for u=1:256
       if(Cd_green(v) >=Cr_green(u))
          if(u==256)
              M_g(v)=u;
              break;
          end
          if(Cd_green(v)<Cr_green(u+1))
              M_g(v)=u;
              break;
          end
       end
   end
   for u=1:256
       if(Cd_blue(v) >=Cr_blue(u))
          if(u==256)
              M_b(v)=u;
              break;
          end
          if(Cd_blue(v)<Cr_blue(u+1))
              M_b(v)=u;
              break;
          end
       end
   end
end

modifiedImage = changedImage;
%Dopasowanie koloru
for w=1:width
    for h=1:height
        modifiedImage(h,w,1) = uint8(M_r(changedImage(h,w,1)+1));
        modifiedImage(h,w,2) = uint8(M_g(changedImage(h,w,2)+1));
        modifiedImage(h,w,3) = uint8(M_b(changedImage(h,w,3)+1));
    end
end

end

