function localDataPath = local_data_path



homeDataPath = '/Users/paulmiddlebrooks/matlab/local_data/';
tebaDataPath = '/Volumes/SchallLab/data/';
if isdir(tebaDataPath)
    localDataPath = '/Users/paulmiddlebrooks/matlab/local_data/';
elseif isdir (homeDataPath)
    localDataPath = '/Users/paulmiddlebrooks/matlab/local_data/';
else
    disp('If you''re at work you may need to connect to teba')
    return
end

