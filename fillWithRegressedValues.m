function out=fillWithRegressedValues(data)
% replaces missing values in the n observations x d dimensions matrix data
% with values predicted by linearly regression. This is done column-wise,
% with all d-1 other columns being used to predict the missing values in
% the remaining column.
 
numCols=size(data,2);

regressedYs=zeros(size(data));

%for all columns
for i=1:numCols
   
    % isolate the column being modeled
    y=data(:,i);
    X=data;
    X(:,i)=[];
    
    % fill in missing values on regressors with the mean across their
    % respective dimensions
    Xmeans=repmat(nanmean(X),size(data,1),1);
    Xfilled=X;
    Xfilled(isnan(Xfilled))=Xmeans(isnan(Xfilled));
    
    % remove rows with missing y-values for model fitting
    Xsub=Xfilled;
    Xsub(isnan(y),:)=[];
    ysub=y;
    ysub(isnan(y))=[];
    
    % fit model and collected predicted values
    linModel=fitlm(Xsub,ysub);
    regressedYs(:,i)=predict(linModel,Xfilled);
    
end

out=data;
out(isnan(out))=regressedYs(isnan(out));


