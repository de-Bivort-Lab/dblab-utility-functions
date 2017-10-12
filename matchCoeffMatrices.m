function out=matchCoeffMatrices(C1,C2,weights,params)
% attempts to match a loading (coeff) matrix C2 to a target loading matrix
% C1. The match is evaluated by the weighted sum of column-wise correlation
% coeffcients between the two matrixes. weights provides the weights.
% Reasonable to use the latent (sorted eigenvalues) variable from the PCA
% run used to calculate C2. 

visBool=1;              % make a plot of the monte carlo performance history?
shuffleTries=100000;    % how long to run the monte carlo
maxPCs=25;              % ignore PCs beyond this cutoff
swapCount=4;            % how many pairs of columns to swap at a time

if isfield(params,'visBool'); visBool=params.visBool; end
if isfield(params,'shuffleTries'); visBool=params.shuffleTries; end
if isfield(params,'maxPCs'); visBool=params.maxPCs; end
if isfield(params,'swapCount'); visBool=params.swapCount; end

numPCs=min([size(C1,2) size(C2,2)]);
numDims=size(C1,1);
perfHist=zeros(shuffleTries,1);

C1Partial=C1(:,1:maxPCs);
C2Partial=C2(:,1:maxPCs);

%initialize montecarlo dummy variables
weights=weights/sum(weights);
weights=weights(1:maxPCs);
rho=corr(C1Partial,C2Partial);
bestMatchScore=sum(rho(boolean(eye(maxPCs))).*weights);
bestCoeffMatrix=C2;
bestPermVector=1:numPCs;

if visBool==1; h=waitbar(0,'progress'); end

for i=1:shuffleTries
    
    %permute columns in C2
    tempPermVec=1:numPCs;
    for k=1:swapCount
        permTemp=randperm(numPCs,2);
        A=tempPermVec;
        tempPermVec(permTemp(1))=A(permTemp(2));
        tempPermVec(permTemp(2))=A(permTemp(1));
    end
    
    % with p=0.5 switch the polarity of a random column of C2
    tempSignMatrix=ones(numDims,numPCs);
    if rand<0.5
        randCol=randi(numPCs);
        tempSignMatrix(:,randCol)=-tempSignMatrix(:,randCol);
    end
    
    %apply the permutation and polarity switch to the current best estimate
    tempCoeffMatrix=bestCoeffMatrix;
    tempCoeffMatrix=tempCoeffMatrix(:,tempPermVec).*tempSignMatrix;
    tempCoeffMatrixPartial=tempCoeffMatrix(:,1:maxPCs);
    
    %evaluate the match quality
    rho=corr(C1Partial,tempCoeffMatrixPartial);
    tempMatchScore=sum(rho(boolean(eye(maxPCs))).*weights);
    
    %did it improve the match?
    if tempMatchScore > bestMatchScore
        bestMatchScore=tempMatchScore;
        bestCoeffMatrix=tempCoeffMatrix;
        bestPermVector=bestPermVector(tempPermVec).*tempSignMatrix(1,:);
    end
    
    perfHist(i)=bestMatchScore;
    
    if visBool==1 && mod(i,1000)==0; waitbar(i/shuffleTries,h); end
    
end

% make a plot
if visBool==1
    close(h);
    figure;
    plot(perfHist);
end

out.permutation=bestPermVector;
out.bestCoeffMatrix=bestCoeffMatrix;
out.perfHist=perfHist;