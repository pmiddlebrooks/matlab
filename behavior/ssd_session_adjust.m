function ssdList = ssd_session_adjust(ssdList)

% ssdList = ssd_session_adjust(ssdList)
%
% This function bins SSDs that are temporally near enough each other to be
% considered "the same" SSD. It does this by taking a weighted sum of the
% relative SSDs and returning that "adjusted" value as the "new" SSD.
%
% ssdList is any list of SSDs (from a dataset, e.g.)



% SSDs must be separated by this much time to not be adjusted to match other SSDs near this time
minTime = 5;  
minTime = 10;  

ssdArray = unique(ssdList(~isnan(ssdList)));

a = diff(ssdArray);

% Indices of the SSDs that are less than minTime ms after the previous SSD
ind = find([0; a <= minTime]);

while ~isempty(ind)
   for i = 1 : length(ind)
      iPair = ssdArray([ind(i)-1,ind(i)]);
      
      
      % Which trials have the two SSDs in question?
      earlyTimeTrial = ismember(ssdList, iPair(1));
      lateTimeTrial = ismember(ssdList, iPair(2));
      
      % Take a weighted mean of the 2 SSDs in question
      weightedMean = round((iPair(1) * sum(earlyTimeTrial) + iPair(2) * sum(lateTimeTrial)) / sum([earlyTimeTrial; lateTimeTrial]));
      
      % Replace old SSDs with new one
      ssdList(earlyTimeTrial) = weightedMean;
      ssdList(lateTimeTrial) = weightedMean;
      
   end
   
   % Check to see if there are still SSDs close enough temporally that they
   % need to be joined (in loop above)
   ssdArray = unique(ssdList(~isnan(ssdList)));
   a = diff(ssdArray);
   ind = find([0; a < minTime]);
end