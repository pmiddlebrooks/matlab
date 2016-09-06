function Data = ccm_population_roit_shad_2002(subject, projectRoot, projectDate, opt)
%
% function ccm_population_roit_shad_2002(Data, opt)
%
% Replicates figure 7 of Roitman & Shadlen 2002 J Neuroscience.
%
% For the choice countermanding data, the figure is replicated twice: Once
% for go trials, once for noncanceled stop trials.
%
%


%%
% Copied and modified from ccm_session_data_plot
% Set defaults

if nargin < 4
    opt.subject         = 'broca';
    opt.epochArray      = {'checkerOn','responseOnset'};
    opt.doStops         = true;
    opt.plotError     	= true;
    opt.plotSEM         = false;
    opt.categoryName   	= 'presaccRamp';
    opt.printPlot   	= true;
    opt.dataType        = 'neuron';
    if nargin == 0, Data = opt; return, end
end

% ____________________ CONSTANTS AND VARIABLES ____________________
printPlot       = true; % opt.printPlot;
% filterData      = opt.filterData;
% stopHz          = opt.stopHz;

goOutcomeArray      = {'goTarg'}; %{'goTarg', 'goDist'};
stopOutcomeArray    = {'stopTarg'}; %{'stopTarg', 'stopDist'};
conditionArray       = {'easyIn', 'easyOut', 'hardIn', 'hardOut'};

inStyle = '-';
outStyle = '--';

goTargStyle = '-';
goDistStyle = '--';
stopTargStyle = '-';
stopDistStyle = '--';
stopStopStyle = '-';

goEasyColor = [0 .8 0];
goHardColor = [0 .3 0];
stopEasyColor = [.8 0 0];
stopHardColor = [.3 0 0];
stopStopColor = [0 0 0];



% ____________________    LOAD DATA    ____________________
dataPath = fullfile(projectRoot,'data',projectDate,subject);
load(fullfile(dataPath, ['ccm_',opt.categoryName,'_neuron_population'])) % Load Data struct for that population









%   ____________________ SET UP PLOT  ____________________
lineWidth = 2;  % for all conditions right now
inOutStyle = {inStyle, outStyle, inStyle, outStyle};  % {'goTarg', 'goDist'};
% goOutcomeStyle = {goTargStyle, goDistStyle};  % {'goTarg', 'goDist'};
% stopOutcomeStyle = {stopTargStyle, stopDistStyle};  % {'stopTarg', 'stopDist'};

goInOutColor = [goEasyColor; goEasyColor; goHardColor; goHardColor];
stopInOutColor = [stopEasyColor; stopEasyColor; stopHardColor; stopHardColor];
% goAccuracyColor = [goEasyColor; goHardColor];
% stopAccuracyColor = [stopEasyColor; stopHardColor];



nRow = length(opt.epochArray);
nCol = 2;
figureHandle = 843;


if printPlot
    [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_landscape(nRow, nCol, figureHandle);
else
    [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = screen_figure(nRow, nCol, figureHandle);
end
clf


% Define axes limits
switch opt.dataType
    case 'neuron'
        yLimMax = 60;
        yLimMin = 10;
    case {'erp','lfp'}
        yLimMax = .04;
        yLimMin = -.04;
end

            % _______  Set up axes  ___________
            % axes names
            axGo = 1;
            axStop = 2;
            for e = 1 : length(opt.epochArray)
             epochRange = ccm_epoch_range(opt.epochArray{e}, 'plot');
            
            
            % Set up plots
            % Go trials
            ax(axGo, e) = axes('units', 'centimeters', 'position', [xAxesPosition(axGo, e) yAxesPosition(axGo, e) axisWidth axisHeight]);
         hold(ax(axGo, e), 'on')
%             set(ax(axGo, e), 'ylim', [yLimMin yLimMax], 'xlim', [epochRange(1) epochRange(end)])
            set(ax(axGo, e), 'ylim', [yLimMin yLimMax], 'xlim', [1 epochRange(end) - epochRange(1)])
            cla
            hold(ax(axGo, e), 'on')
            plot(ax(axGo, e), [-epochRange(1) -epochRange(1)], [yLimMin yLimMax * .9], '-k', 'linewidth', 2)
            title(opt.epochArray{e})
            
            % Stop trials
            ax(axStop, e) = axes('units', 'centimeters', 'position', [xAxesPosition(axStop, e) yAxesPosition(axStop, e) axisWidth axisHeight]);
         hold(ax(axStop, e), 'on')
%             set(ax(axStop, e), 'ylim', [yLimMin yLimMax], 'xlim', [epochRange(1) epochRange(end)])
             set(ax(axStop, e), 'ylim', [yLimMin yLimMax], 'xlim', [1 epochRange(end) - epochRange(1)])
           cla
            hold(ax(axStop, e), 'on')
            plot(ax(axStop, e), [-epochRange(1) -epochRange(1)], [yLimMin yLimMax * .9], '-k', 'linewidth', 2)
            title(opt.epochArray{e})
            end

            
            


% Loop through epochs
for e = 1 : length(opt.epochArray)
             epochRange = ccm_epoch_range(opt.epochArray{e}, 'plot');

    % Loop colorherence (easyIn, easyOut, hardIn, hardOut)
    for c = 1 : length(conditionArray)
        
        
        %   _______ GO TRIALS  _______
        for o = 1 : length(goOutcomeArray)
            meanSDF = mean(Data.(conditionArray{c}).(goOutcomeArray{o}).(opt.epochArray{e}).sdf);
            align = Data.(conditionArray{c}).(goOutcomeArray{o}).(opt.epochArray{e}).align;
            if strcmp(opt.epochArray{o}, 'checkerOn')
                meanSDF = meanSDF(1 : round(mean(Data.(conditionArray{c}).(goOutcomeArray{o}).rt))+align);
           end
            plot(ax(axGo, e), meanSDF(align+epochRange(1):end), 'LineWidth',lineWidth,'LineStyle',inOutStyle{c},'color',goInOutColor(c,:))
        end % Go trials
        
        
        %   _______ STOP TRIALS  _______
        for o = 1 : length(stopOutcomeArray)
            meanSDF = mean(Data.(conditionArray{c}).(stopOutcomeArray{o}).(opt.epochArray{e}).sdf);
            align = Data.(conditionArray{c}).(stopOutcomeArray{o}).(opt.epochArray{e}).align;
            if strcmp(opt.epochArray{o}, 'checkerOn')
                meanSDF = meanSDF(1 : round(mean(Data.(conditionArray{c}).(stopOutcomeArray{o}).rt))+align);
            end
            plot(ax(axStop, e), meanSDF(align+epochRange(1):end), 'LineWidth',lineWidth,'LineStyle',inOutStyle{c},'color',stopInOutColor(c,:))            
        end % Stop trials
        
    end  % colorCohArray
    
end % epochs

if opt.printPlot
    filePath = fullfile(projectRoot,'results',projectDate,subject);
fileName = ['pop_roit_shad_',opt.categoryName,'.pdf'];
    print(figureHandle, fullfile(filePath, fileName), '-dpdf', '-r300')
end
return

% ________________________________________________________________________________
% ________________________________________________________________________________
% ________________________________________________________________________________
% ________________________________________________________________________________
% ________________________________________________________________________________

