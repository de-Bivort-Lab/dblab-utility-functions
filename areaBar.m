function areaBar(X,Y,E,lineColor,areaColor)
% areabar(X,Y,E,lineColor,areaColor) produces a line plot of vector Y vs
% vector X, with error E on each point represented as a shaded area behind
% the line plot. lineColor and areaColor are 1x3 vectors of RGB values
% between 0 and 1. I.e. [0 0 1] is blue and [0.8 0.8 1] is light blue.


holdBool=ishold;

if size(X,1)~=1
    X=X';
end

if size(Y,1)~=1
    Y=Y';
end

if min(size(E))==1
    if size(E,1)~=1
        E=E';
    end
elseif min(size(E))==2
    if numel(E)==4
        warning('error array E is 2x2, has ambiguous orientation');
    elseif size(E,1)~=2
        E=E';
    end
end


Xall=[X fliplr(X)];

if size(E,1)==1
    
    Yall=[Y+E fliplr(Y)-fliplr(E)];
    
elseif size(E,1)==2
    if min(min(E))>0
    Yall=[Y+E(1,:) fliplr(Y)-fliplr(E(2,:))];
    else
        Yall=[Y+E(1,:) fliplr(Y)+fliplr(E(2,:))];
    end
end

hold on;
fill(Xall,Yall, areaColor,'LineStyle','none');

plot(X,Y,'Color', lineColor);

if holdBool
    hold on;
else
    hold off;
end