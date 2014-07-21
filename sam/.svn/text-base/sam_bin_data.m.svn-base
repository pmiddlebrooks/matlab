function [rtQ,pDefect,f,pM] = sam_bin_data(rt,p,n,q,minSize)
% SAM_BIN_DATA <Synopsis of what this function does>
%
% DESCRIPTION
% <Describe more extensively what this function does>
%
% Let there be N task conditions and M trial types (e.g. GoCorrect,
% GoIncorrect, StopFailure)
%
%
%
% SYNTAX
% [rtQ,f] = SAM_BIN_DATA(rt,p,n,q,minSize);
%
% rt - reaction times (NxM cell)
% p - response probability (NxM double)
% n - total number of trials (NxM double)
% q - quantiles
% minSize - minimum number of trials for binning (1x1 double)
%
%
% EXAMPLES
%
% .........................................................................
% Bram Zandbelt, bramzandbelt@gmail.com
% $Created : Wed 28 Aug 2013 14:40:48 CDT by bram
% $Modified: Wed 28 Aug 2013 15:28:13 CDT by bram
 
% CONTENTS
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. PROCESS INPUTS AND SPECIFY VARIABLES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If the number of trials is less than required, use just one bin
if n.*p < minSize;
  q = [0 1];
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. COMPUTE QUANTILES, PROBABILITIES, PROBABILITY MASSES, AND FREQUENCIES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% RT quantiles
% =========================================================================
if isempty(rt)
  rtQ = quantile([1e4],q);
else
  rtQ = quantile(rt,q);
end

% This ensures that the slowest RT falls within the bin, instead of falling
% in a separate bin
if n.*p < minSize;
  rtQ(2) = rtQ(2) + 1;
end

% Defective cumulative probabilities
% =========================================================================
pDefect = q.*p;

% Probability masses
% =========================================================================
if isempty(rt)
  histCount = histc([1e4],[-Inf,rtQ,Inf]);
  histCount = histCount(1:end-1);
  pM = p.*histCount./sum(histCount);
  pM = pM(:);
else
  histCount = histc(rt,[-Inf,rtQ,Inf]);
  histCount = histCount(1:end-1);
  pM = p.*histCount./sum(histCount);
  pM = pM(:);
end

% Frequencies
% =========================================================================
f = pM.*n;