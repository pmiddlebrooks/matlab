%%
figure(10);
hold all
cellfun(@(x,y) plot(x,y, 'k'), goEyeX{1,1}, goEyeY{1,1})

% plot(goEyeX{1,1}, goEyeY{1,1})

degX = cellfun(@(x) sqrt(x), cellfun(@(x,y) x^2 + y^2, goEyeX{1,1}, goEyeY{1,1}))


velX{d, i} = cellfun(@(x) [0; diff(x(:))], degX, 'uni', false);


scatter(trialData.rt(goTrial{d, i}), cellfun(@max, goVel{d, i}))


%% Add hemisphere to translated data file
subject = 'joule';
session = {'jp061n02'};
tebaPath = '/Volumes/SchallLab/data/';


for i = 1 : length(session)
[~, SessionData] = load_data(subject, session{i});

SessionData.hemisphere = 'left';

save(fullfile(local_data_path, subject, [session{i}, '.mat']), 'SessionData', '-append')
save(fullfile(tebaPath, subject, [session{i}, '.mat']), 'SessionData', '-append')


end

%%
plexon_translate_datafile_mac('joule','jp060n02');
