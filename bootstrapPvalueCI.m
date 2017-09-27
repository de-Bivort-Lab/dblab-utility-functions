function out=bootstrapPvalueCI(k,n)
% calculates the 95% likelihood interval for bootstrap estimates of
% p-values. n is the number of replicates performed, and k is the number of
% instances in which, under the null hypothesis, a test statistic greater
% than that observed in the experimental data was observed in the bootstrap
% resamples.

resRes=10000;

if k>0
    
    doneBool=0;
    sup975=1;
    inf975=0;
    
    
    while doneBool==0
        
        vals=linspace(inf975,sup975,resRes);
        probs=zeros(length(vals),1);
        for i=1:length(vals);
            probs(i)=binocdf(k,n,vals(i));
        end
        
        if sum(probs>0.975)>1
            doneBool=1;
        else
            disp('rescaling');
            sup975=vals(2);
        end
        
    end
    
    x1=find(probs>0.975);
    x1=length(x1);
    x2=x1+1;
    
    CI975=interp1([probs(x1) probs(x2)], [vals(x1) vals(x2)], 0.975);
    
else
    CI975=0;
end

doneBool=0;
sup25=1;
inf25=0;
while doneBool==0
    
    vals=linspace(inf25,sup25,resRes);
    probs=zeros(length(vals),1);
    for i=1:length(vals);
        probs(i)=binocdf(k,n,vals(i));
    end
    
    if sum(probs>0.025)>1
        doneBool=1;
    else
        disp('rescaling');
        sup25=vals(2);
    end
    
end

x1=find(probs>0.025);
x1=length(x1);
x2=x1+1;

CI25=interp1([probs(x1) probs(x2)], [vals(x1) vals(x2)], 0.025);

out=[CI975 CI25];