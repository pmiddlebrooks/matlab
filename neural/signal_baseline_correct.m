function signal = signal_baseline_correct(signal, baseWindow, alignIndex)


% INPUT
%
% signal:          a matrix of trials (rows) of eeg data (time in columns) aligned.
%
% baseWindow: window of time relative to alignment index to zero (thus
%   shift whole signal by that amount).
%
% alignIndex: Index with the signal upon which the data is aligned.


% for i = 1 : 2 : length(varargin)
%    switch varargin{i}
%       case 'baseWindow'
%          baseWindow = varargin{i+1};
%       case 'alignIndex'
%          alignIndex = varargin{i+1};
%       otherwise
%    end
% end



nTrial      = size(signal, 1);

for i = 1 : nTrial
   iBase        = nanmean(signal(i, alignIndex + baseWindow));
   signal(i, :)    = signal(i, :) - iBase;
end
