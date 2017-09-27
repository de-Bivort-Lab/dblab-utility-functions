function out=violinPlot(data)

bufferWidth=1;
numPts=100;
violinColor=[0.8 0.8 0.8];

switch class(data)
    case 'double'
        numVectors=size(data,2);
        dataTemp={};
        for i=1:numVectors
            dataTemp=[dataTemp data(:,i)]; 
        end
        data=dataTemp;
    case 'cell'
        numVectors=length(data);
end

figure;
hold on;

fs=zeros(numPts,numVectors);
xis=zeros(numPts,numVectors);
fs2=zeros(numPts+2,numVectors);
xis2=zeros(numPts+2,numVectors);

for i=1:numVectors
    [fs(:,i),xis(:,i)] = ksdensity(data{i});
    %    fill([i-f i+fliplr(f)],[xi fliplr(xi)],[0.9 0.9 0.9]);
    
    xis2(:,i)=sort([xis(:,i);0;1]);
    fs2(:,i)=interp1(xis(:,i),fs(:,i),xis2(:,i),'spline',0);
end

fs=fs/(max(max(fs))*(2+bufferWidth));

for i=1:numVectors
    h=fill([i-fs(:,i)' i+fliplr(fs(:,i)')],[xis(:,i)' fliplr(xis(:,i)')],violinColor);
    h.EdgeColor='none';
end

out.xis=xis;
out.fs=fs;

% stuff specific to crumbcake analysis:
% 


% thresholdVector=zeros(numVectors,1);
% thresholdVector(numVectors/2+1)=1;
% thresholdBool=1;


% if thresholdBool==1
%     fs2=fs2/(max(max(fs2))*(2+bufferWidth));
%     
%     for i=1:numVectors
%         ftemp=fs2(:,i);
%         xtemp=xis2(:,i);
%         centroidTemp=sum(xtemp.*ftemp)/sum(ftemp);
%        xtemp
%         if centroidTemp<thresholdVector(i)
%             whereToDelete=xtemp<thresholdVector(i);
%         else
%             whereToDelete=xtemp>thresholdVector(i);
%         end
%         ftemp(whereToDelete)=[];
%         xtemp(whereToDelete)=[];
%         centroidTemp
%         thresholdVector(i)
%         whereToDelete
%         out(i)=sum(ftemp)/sum(fs(:,i));
% 
%         h=fill([i-ftemp' i+fliplr(ftemp')],[xtemp' fliplr(xtemp')],[0.4 0.7 0.4]);
%         
%         h.EdgeColor='none';
%         text(i,max(max(xis))*1.1,num2str(out(i),2),'HorizontalAlignment','center');
%     end
%     
% end