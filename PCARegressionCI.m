function out=PCARegressionCI(data)
% performs linear regression on the two column variables of data
% using PCA to find the regression fit, i.e., using normals to compute
% residuals
%
% performs bootstrap resampling of this regression to determine the
% confidence interval of the regression line.

% configure parameters here:
numReps=3000;   % # of bootstrap replicates
CI=95;          % confidence interval to be estimated
plotBool=1;     % make a figure at the end?

numPts=size(data,1);

% generate points for line and CI
numXs=100;
minX=min(data(:,1));
maxX=max(data(:,1));
xPts=linspace(minX-0.2*(maxX-minX),maxX+0.2*(maxX-minX),numXs);

out.fitVals=zeros(numReps,numXs);

% bootstrap loop
h=waitbar(0,'resampling progress');
for i=1:numReps
    dataTemp=data(randi(numPts,[numPts 1]),:);
    [eigenvectors,~,~] = pca(dataTemp);
    x_bar=mean(dataTemp(:,1));
    y_bar=mean(dataTemp(:,2));
    m=eigenvectors(2,1)/eigenvectors(1,1);
    out.fitVals(i,:)=m*xPts+(y_bar-m*x_bar);
    waitbar(i/numReps,h);
end
close(h);

% save CI bounds
out.lower=prctile(out.fitVals,(100-CI)/2);
out.upper=prctile(out.fitVals,(100-(100-CI)/2));

% make a figure if plotBool==1.
if plotBool==1
    figure;
    hold on;
    patch([xPts fliplr(xPts)],[out.lower fliplr(out.upper)],[0 0 0],'faceAlpha',0.2,'edgeColor','none');
    plot([xPts(1) xPts(end)],[mean(out.fitVals(:,1)) mean(out.fitVals(:,end))],'k');
    scatter(data(:,1),data(:,2),'k.');
end
