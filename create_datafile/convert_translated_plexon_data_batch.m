%%

function convert_translated_plexon_data_batch(monkey, partNumber)
% partNumber: e.g. for bp016n01, partNumber = 16


partNumberString = num2str(partNumber, '%03.0f')

if regexp('broca', monkey, 'ignorecase')
        monkeyDataPath = 'Broca/';
elseif regexp('xena', monkey, 'ignorecase')
        monkeyDataPath = 'Xena/Plexon/';
else
    disp('Wrong monkey name?')
        return
end
tebaDataPath = ['t:/data/',monkeyDataPath]

dataStructure = dir([tebaDataPath, '*', partNumberString, '*'])
size(dataStructure, 1)
for i = 1 : size(dataStructure, 1)
    if ~isempty(regexp(dataStructure(i).name, '_legacy', 'once')) && isempty(regexp(dataStructure(i).name, '2012', 'once'))
    dataStructure(i).name(1:end-4)
 [trialData, sessionData] = convert_translated_plexon_data(monkey, dataStructure(i).name(1:8));
    end
end
% for i = 1 : size(dataStructure, 1)
%     dataStructure(i).name
%     regexp(dataStructure(i).name, '_legacy', 'once')
%     end
% end
%%
%  for partNumber = 10 : 51
% monkey = 'broca';
% partNumberString = num2str(partNumber, '%03.0f')
% 
% tebaDataPath = '/Volumes/SchallLab/data/Broca/';
% 
% dataStructure = dir([tebaDataPath, '*', partNumberString, '*'])
% size(dataStructure, 1)
% for i = 1 : size(dataStructure, 1)
%     if ~isempty(regexp(dataStructure(i).name, '_legacy', 'once')) && isempty(regexp(dataStructure(i).name, '2012', 'once'))
%     dataStructure(i).name(1:end-4)
%  [trialData, sessionData] = convert_translated_plexon_data(monkey, dataStructure(i).name(1:8));
%     end
% end
% end