function vectorPixels(data,colormap,border)
% generates vector art of a heatmap given in data, with colormap. border is
% an RGB triple defined on 0-1 that indicates the color of border of the rectangles

H=size(data,1);
W=size(data,2);
numColors=size(colormap,1);

data(data<1)=1;
data(data>numColors)=numColors;
data=round(data);



for i=1:H
   for j=1:W 
    rectangle('Position', [(j-1)/W (H-i)/H  1/W 1/H], 'FaceColor', colormap(data(i,j),:), 'EdgeColor',border);
    
    
   end
end

set(gca,'YTick',[],'XTick',[]);