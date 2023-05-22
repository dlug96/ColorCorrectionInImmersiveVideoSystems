function [synthView, synthDepth] = synthesizeVirtualView(imageView, imageDepth, cameraParamsINChangedView, cameraParamsINGoalView, cameraParamsOUTChangedView, cameraParamsOUTGoalView, width, height, Znear, Zfar)
%Synthesize Nowy widok + g³êbia

imageRealCam = imageView;
yCamDepth = imageDepth;

Kr = cameraParamsINChangedView;
Kv = cameraParamsINGoalView;

RTr = cameraParamsOUTChangedView;
RTv = cameraParamsOUTGoalView;

 %Macierze projekcji
 Pr = Kr*RTr;
 Pv = Kv*RTv;
 P = Pv/Pr;

% Obliczenie wartoœci g³ebi Zr wg wzoru 1/Zr = Z/255 * Z'near + 1/Zfar
m_dInvZNearMinusInvZFar = 1/Znear - 1/Zfar;

Zr = zeros(height,width);
for h=1:height
   for w=1:width
        Z = double(yCamDepth(h,w,1));
        Zr(h,w) = Z/65535 * m_dInvZNearMinusInvZFar + 1/Zfar;
        Zr(h,w) = (1/Zr(h,w));      
   end
end

% Synteza widoku wirtualnego kamery
x_v = zeros(height,width);
y_v = zeros(height,width);
z_v = zeros(height,width);

Z_new = zeros(height,width);

for h=1:height
   for w=1:width
       val = P * [w*Zr(h,w);h*Zr(h,w);Zr(h,w);1];
       invZ = 1 / val(3);
       x_val = ceil(val(1) * invZ);
       y_val = ceil(val(2) * invZ);
       if(x_val > 0 && x_val < width && y_val > 0 && y_val < height)
           %[x_val y_val invZ]
           if(z_v(y_val,x_val) < invZ)
               x_v(h,w) = x_val;
               y_v(h,w) = y_val;
               z_v(y_val,x_val) = invZ;
               
               
               Zz = double(double(invZ-1/Zfar)/double(m_dInvZNearMinusInvZFar));
               Zz = uint16(Zz * 65535);
               Z_new(y_val,x_val)= Zz;
               
           end
       end
   end
end

synthDepth = uint16(Z_new);
imageVirtual = double(zeros(height, width, 3));

% Rzutowanie kolorów na obraz wirtualny
for h=1:height
   for w=1:width
       x = x_v(h,w);
       y = y_v(h,w);
       if(x == 0 || y == 0)
           
       else
       imageVirtual(y,x,1) = imageRealCam(h,w,1,1);
       imageVirtual(y,x,2) = imageRealCam(h,w,2,1);
       imageVirtual(y,x,3) = imageRealCam(h,w,3,1);
       
       end
   end
end

synthView = uint8(imageVirtual);

end

