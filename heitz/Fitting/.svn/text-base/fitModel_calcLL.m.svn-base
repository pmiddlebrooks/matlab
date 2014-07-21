% Objective function returning the -Log Liklihood for MLE
%
% RPH

function [LL] = fitModel_calcLL(param,data,model_name)

    %Likelihood = p(data | model (or hypothesis)) whereas NHST uses p(model | data)
    
    
    %==============================================
    % Explanation of minimizing the -log likelihood
    %
    % e.g., suppose data vector ([1 2]) with true normal distribution of mu = 1, std = 1
    %
    % 1)    If we don't use the log, we take the product:
    %       LL = prod(normpdf([1 2],1,1)) = 0.0965
    %       LL = prod(normpdf([1 10],1,1)) = 4.1010e-19
    %
    %       Matlab wants to minimize, but we want to maximize (note the first LL is greater than the
    %       second LL; we want to keep that up.  Because ML wants to minimize, we can just make it
    %       negative:
    %       LL = -prod(normpdf([1 2],1,1)) = -0.0965
    %       LL = -prod(normpdf([1 10],1,1)) = -4.1010e-19
    %       Now, note the first LL is more negative (closer to -inf) than the 2nd one.  If we kept that
    %       up, we'd eventually find the lowest possible -LL, which is the highest possible +LL.
    %
    %       However, when dealing with large vectors of numbers, you quickly run into the limits of ML,
    %       and the prod will end up being 0.  To combat that, we use the log.  In log space,
    %       multiplication == summation.  So, this is equivalent:
    %
    %       LL = -sum(log(normpdf([1 2],1,1))) = 2.3379
    %       LL = -sum(log(normpdf([1 10],1,1))) = 42.3379
    %       Note again that the lower the -logLL, the higher the actual Likelihood, because:
    %           exp(-2.3379) = 0.0965
    %           exp(-42.3379) = 4.1009e-19
    %           So, the first one is greater than the 2nd one, which is what we want.
    
    
    
    if strmatch('norm',model_name,'exact')
        u = param(1);
        sigma = param(2);

        LL = -sum(log(normpdf(data,u,sigma)));

    elseif strmatch('weib',model_name,'exact')
        scale = param(1);
        shape = param(2);

        LL = -sum(log(wblpdf(data,scale,shape)));

    elseif strmatch('exp',model_name,'exact')
        mu = param(1);

        LL = -sum(log(exppdf(data,mu)));

    elseif strmatch('exGauss',model_name,'exact')
        mu = param(1);
        sigma = param(2);
        tau = param(3);

        LL = -sum(log(exGaussPDF(data,mu,sigma,tau)));
        
    else
        error('Model type not set or does not exist...')
    end

end