function [mergedView, mergedDepth] = mergeViewsV2(view0, depth0, view1, depth1, goalDepth, width, height)
%mergeViews £¹czy 2 widoki na podstawie map g³êbi

mergedView = zeros(height,width);
mergedDepth = zeros(height,width);
v0 = double(view0);
v1 = double(view1);
for w=1:width
   for h=1:height
      d0 = abs(double(goalDepth(h,w))-double(depth0(h,w)));
      d1 = abs(double(goalDepth(h,w))-double(depth1(h,w)));
      if(d0<d1)
          mergedView(h,w,1)=v0(h,w,1);
          mergedView(h,w,2)=v0(h,w,2);
          mergedView(h,w,3)=v0(h,w,3);
          mergedDepth(h,w)=depth0(h,w);
      elseif(d0>d1)
          mergedView(h,w,1)=v1(h,w,1);
          mergedView(h,w,2)=v1(h,w,2);
          mergedView(h,w,3)=v1(h,w,3);
          mergedDepth(h,w)=depth1(h,w);
      else
          mergedView(h,w,1)=(v0(h,w,1)/2) + (v1(h,w,1)/2);
          mergedView(h,w,2)=(v0(h,w,2)/2) + (v1(h,w,2)/2);
          mergedView(h,w,3)=(v0(h,w,3)/2) + (v1(h,w,3)/2);
          mergedDepth(h,w)=depth1(h,w);
      end
   end
end

end
