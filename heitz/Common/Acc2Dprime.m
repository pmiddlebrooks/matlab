%compute 'equivalent' accuracy rate from d-prime
function [Dprime] = Acc2Dprime(Acc)

%Dprime is z-score difference between 2 normal distributions centered on z(hits) and z(false alarms).
%Dprime = z(hits) - z(false alarms).
%
%If we know an accuracy rate, we can assume that this was the hits - false alarm rate, or assume that the
%false alarm rate is 0, and then the accuracy rate is just what is left over.  find the z-score
%corresponding to that difference
%
% RPH

if Acc > 1; error('Enter accuracy rate in decimal'); end

Dprime = norminv(Acc,0,1);