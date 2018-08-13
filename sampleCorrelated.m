function out=sampleCorrelated(r,n,N)
% samples n 2d normally distributed, correlated with a coefficient of r, N
% times, recording and returning the sampled r and p-value for each of the 
% N samples. Writes into the command window the estimated power of an
% experiment to detect a correlation coefficient of r, with n samples, at
% an alpha value of 0.05.
%
%Output has object: sampleStats = Nx2 array of r and p values for each 
%                                 sample
%                   samples = most recent nx2 sample of multivariate random 
%                             values
%                  

out.sampleStats=zeros(N,2);

for i=1:N
    sample=mvnrnd([0 0],[1 r;r 1],n);
    [rho,p]=corr(sample(:,1),sample(:,2));
   out.sampleStats(i,:)= [rho,p];
end

out.sample=sample;

alpha=0.05;
pow=sum(out.sampleStats(:,2)<alpha)/N;
frac=sum(out.sampleStats(:,1)>0)/N;


disp(['assuming alpha= ' num2str(alpha)]);
disp(['statistical power = ' num2str(pow,2)]);
disp(['fraction consistent = ' num2str(frac,2)]);