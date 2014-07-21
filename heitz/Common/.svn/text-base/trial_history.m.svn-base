%finds patterns of correct/errors (trial history)

% capital letter = current trial
% lower case letter = previous trial
% i/I = incorrect
% c/C = correct

crt = Correct_(:,2)';


%Correction for SAT task; missed deadlines sometimes coded as incorrect in 'Correct_' variable but are
%technically correct if not for the deadline.
crt(find(Errors_(:,6) == 1 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3)));
crt(find(Errors_(:,7) == 1 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3)));

%need to tack on 1 because strfind gives 1st indices;
iI = strfind(crt,[0 0])' + 1;
iC = strfind(crt,[0 1])' + 1;
cI = strfind(crt,[1 0])' + 1;
cC = strfind(crt,[1 1])' + 1;


