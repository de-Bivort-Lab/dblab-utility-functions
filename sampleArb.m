function out=sampleArb(pdf)
% draws a random integer from 1 to length(pdf) using the a normalized 
% version of the distribution pdf. Uses the CDF^-1 method

if min(size(pdf))>1
    error('input pdf needs to be 1xn or nx1');
else
    if size(pdf,1)>1
        pdf=pdf';
    end
end

cdf=cumsum(pdf)/sum(pdf);

out=sum(rand > [0 cdf(1:end-1)]);