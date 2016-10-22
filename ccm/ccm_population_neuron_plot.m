function Data = ccm_population_neuron_plot(subject, projectRoot, projectDate, opt)
%
% function ccm_population_neuron_plot(Data, opt)
%
% Plots avg sdfs from a given population of neurons.
%


%%
% Copied and modified from ccm_session_data_plot
% Set defaults

if nargin < 4
    opt.epochArray      = {'targOn','checkerOn','stopSignalOn','responseOnset','rewardOn'};
    opt.epochArray      = {'targOn','checkerOn','stopSignalOn','responseOnset'};
    opt.doStops         = true;
    opt.plotError     	= true;
    opt.easyOnly     	= false;
    opt.normalizeData         = false;
    opt.plotSEM         = false;
    opt.categoryName   	= 'presacc';
    opt.printPlot   	= true;
    opt.dataType        = 'neuron';
    if nargin == 0, Data = opt; return, end
end

if ~opt.doStops
        opt.epochArray      = {'targOn','checkerOn','responseOnset'};
end

% ____________________ CONSTANTS AND VARIABLES ____________________
printPlot       = true; % opt.printPlot;
% filterData      = opt.filterData;
% stopHz          = opt.stopHz;
% Define axes limits
switch opt.dataType
    case 'neuron'
        yLimMax = 60;
        yLimMin = 10;
    case {'erp','lfp'}
        yLimMax = .04;
        yLimMin = -.04;
end


goOutcomeArray      = {'goTarg'}; %{'goTarg', 'goDist'};
stopOutcomeArray    = {'stopTarg'}; %{'stopTarg', 'stopDist'};
if opt.easyOnly
conditionArray       = {'easyIn', 'easyOut'};
else
conditionArray       = {'easyIn', 'easyOut', 'hardIn', 'hardOut'};
end

inStyle = '-';
outStyle = '--';

% goTargStyle = '-';
% goDistStyle = '--';
% stopTargStyle = '-';
% stopDistStyle = '--';
% stopStopStyle = '-';

goEasyColor = [0 .8 0];
goHardColor = [0 .3 0];
if opt.easyOnly, goEasyColor = goHardColor; end
stopEasyColor = [.8 0 0];
stopHardColor = [.3 0 0];
stopStopEasyColor = [.5 .5 .5];
stopStopHardColor = [0 0 0];



% ____________________    LOAD DATA    ____________________
dataPath = fullfile(projectRoot,'data',projectDate,subject);
load(fullfile(dataPath, ['ccm_',opt.categoryName,'_neuron_population'])) % Load Data struct for that population


if opt.normalizeData
    nSession = length(Data.easyIn.goTarg.rt);
    for i = 1 : nSession
        iNormFactor = max(Data.easyIn.goTarg.responseOnset.sdf(i,:));
        
        for e = 1 : length(opt.epochArray)
            for c = 1 : length(conditionArray)
                for g = 1 : length(goOutcomeArray)
                    if ~strcmp(opt.epochArray{e}, 'stopSignalOn')
                        
                        Data.(conditionArray{c}).(goOutcomeArray{g}).(opt.epochArray{e}).sdf(i,:) = ...
                            Data.(conditionArray{c}).(goOutcomeArray{g}).(opt.epochArray{e}).sdf(i,:) / iNormFactor;
                    end
                end
                
                for s = 1 : length(stopOutcomeArray)
                    Data.(conditionArray{c}).(stopOutcomeArray{s}).(opt.epochArray{e}).sdf(i,:) = ...
                        Data.(conditionArray{c}).(stopOutcomeArray{s}).(opt.epochArray{e}).sdf(i,:) / iNormFactor;
                end
                if ~strcmp(opt.epochArray{e}, 'responseOnset')
                    
                    Data.(conditionArray{c}).stopStop.(opt.epochArray{e}).sdf(i,:) = ...
                        Data.(conditionArray{c}).stopStop.(opt.epochArray{e}).sdf(i,:) / iNormFactor;
                end
            end
        end
    end
end




%   ____________________ SET UP PLOT  ____________________
lineWidth = 3;  % for all conditions right now
inOutStyle = {inStyle, outStyle, inStyle, outStyle};  % {'goTarg', 'goDist'};
% goOutcomeStyle = {goTargStyle, goDistStyle};  % {'goTarg', 'goDist'};
% stopOutcomeStyle = {stopTargStyle, stopDistStyle};  % {'stopTarg', 'stopDist'};

goInOutColor = [goEasyColor; goEasyColor; goHardColor; goHardColor];
stopInOutColor = [stopEasyColor; stopEasyColor; stopHardColor; stopHardColor];
stopStopColor = [stopStopEasyColor; stopStopEasyColor; stopStopHardColor; stopStopHardColor];
% goAccuracyColor = [goEasyColor; goHardColor];
% stopAccuracyColor = [stopEasyColor; stopHardColor];



nCol = length(opt.epochArray);
if ~opt.doStops
    nRow = 2;
else
nRow = 3;
end

figureHandle = 846;


if printPlot
    [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_landscape(nRow, nCol, figureHandle);
else
    [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = screen_figure(nRow, nCol, figureHandle);
end
clf


% _______  Set up axes  ___________
% axes names
axGo = 1;
axStop = 1;
axStopStop = 1;
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
    set(ax(axGo, e), 'xticklabel', get(gca, 'xtick')+epochRange(1)-1)
    if e > 1, set(ax(axGo, e), 'yticklabel', []), end
    
    if opt.doStops
    % Stop trials
    ax(axStop, e) = axes('units', 'centimeters', 'position', [xAxesPosition(axStop, e) yAxesPosition(axStop, e) axisWidth axisHeight]);
    hold(ax(axStop, e), 'on')
    %             set(ax(axStop, e), 'ylim', [yLimMin yLimMax], 'xlim', [epochRange(1) epochRange(end)])
    set(ax(axStop, e), 'ylim', [yLimMin yLimMax], 'xlim', [1 epochRange(end) - epochRange(1)])
    cla
    hold(ax(axStop, e), 'on')
    plot(ax(axStop, e), [-epochRange(1) -epochRange(1)], [yLimMin yLimMax * .9], '-k', 'linewidth', 2)
    set(ax(axStop, e), 'xticklabel', get(gca, 'xtick')+epochRange(1)-1)
    if e > 1, set(ax(axStop, e), 'yticklabel', []), end
    
    
    % Stop Stop trials
    ax(axStopStop, e) = axes('units', 'centimeters', 'position', [xAxesPosition(axStopStop, e) yAxesPosition(axStopStop, e) axisWidth axisHeight]);
    hold(ax(axStopStop, e), 'on')
    %             set(ax(axStopStop, e), 'ylim', [yLimMin yLimMax], 'xlim', [epochRange(1) epochRange(end)])
    set(ax(axStopStop, e), 'ylim', [yLimMin yLimMax], 'xlim', [1 epochRange(end) - epochRange(1)])
    cla
    hold(ax(axStopStop, e), 'on')
    plot(ax(axStopStop, e), [-epochRange(1) -epochRange(1)], [yLimMin yLimMax * .9], '-k', 'linewidth', 2)
    set(ax(axStopStop, e), 'xticklabel', get(gca, 'xtick')+epochRange(1)-1)
    if e > 1, set(ax(axStopStop, e), 'yticklabel', []), end
    end
end





% Loop through epochs
for e = 1 : length(opt.epochArray)
    epochRange = ccm_epoch_range(opt.epochArray{e}, 'plot');
    
    % Loop colorherence (easyIn, easyOut, hardIn, hardOut)
    for c = 1 : length(conditionArray)
        
        
        %   _______ GO TRIALS  _______
        if ~strcmp(opt.epochArray{e}, 'stopSignalOn')
            % Go Targ
            meanSDF = nanmean(Data.(conditionArray{c}).goTarg.(opt.epochArray{e}).sdf, 1);
            align = Data.(conditionArray{c}).goTarg.(opt.epochArray{e}).align;
            plot(ax(axGo, e), meanSDF(align+epochRange(1):end), 'LineWidth',lineWidth,'LineStyle',inOutStyle{c},'color',goInOutColor(c,:))
            
            %                 meanSDF = nanmean(Data.(conditionArray{c}).goDist.(opt.epochArray{e}).sdf, 1);
            %                 align = Data.(conditionArray{c}).goDist.(opt.epochArray{e}).align;
            %                 plot(ax(axGo, e), meanSDF(align+epochRange(1):end), 'LineWidth',lineWidth,'LineStyle',inOutStyle{c},'color',goInOutColor(c,:))
        end
        
        
        
    if opt.doStops
        %   _______ STOP TRIALS  _______
        meanSDF = nanmean(Data.(conditionArray{c}).stopTarg.(opt.epochArray{e}).sdf, 1);
        align = Data.(conditionArray{c}).stopTarg.(opt.epochArray{e}).align;
        plot(ax(axStop, e), meanSDF(align+epochRange(1):end), 'LineWidth',lineWidth,'LineStyle',inOutStyle{c},'color',stopInOutColor(c,:))
        
        %         if ~strcmp(opt.epochArray{e}, 'stopSignalOn')
        %             meanSDF = nanmean(Data.(conditionArray{c}).goFast.(opt.epochArray{e}).sdf, 1);
        %             align = Data.(conditionArray{c}).goFast.(opt.epochArray{e}).align;
        %             plot(ax(axStop, e), meanSDF(align+epochRange(1):end), 'LineWidth',lineWidth,'LineStyle',inOutStyle{c},'color',goInOutColor(c,:))
        %         end
        
        
        %   _______ STOP STOP TRIALS  _______
        if ~strcmp(opt.epochArray{e}, 'responseOnset')
            meanSDF = nanmean(Data.(conditionArray{c}).stopStop.(opt.epochArray{e}).sdf, 1);
            align = Data.(conditionArray{c}).stopStop.(opt.epochArray{e}).align;
            plot(ax(axStopStop, e), meanSDF(align+epochRange(1):end), 'LineWidth',lineWidth,'LineStyle',inOutStyle{c},'color',stopStopColor(c,:))
        end
        %         if ~strcmp(opt.epochArray{e}, 'stopSignalOn')
        %             meanSDF = nanmean(Data.(conditionArray{c}).goSlow.(opt.epochArray{e}).sdf, 1);
        %             align = Data.(conditionArray{c}).goSlow.(opt.epochArray{e}).align;
        %             plot(ax(axStopStop, e), meanSDF(align+epochRange(1):end), 'LineWidth',lineWidth,'LineStyle',inOutStyle{c},'color',goInOutColor(c,:))
        %         end
    end  % colorCohArray
    end
    
end % epochs


h=axes('Position', [0 0 1 1], 'Visible', 'Off');
titleString = sprintf('%s\t n = %d', opt.categoryName , size(Data.easyIn.goTarg.rt, 1));
text(0.5,1, titleString, 'HorizontalAlignment','Center', 'VerticalAlignment','Top')

if opt.printPlot
    filePath = fullfile(projectRoot,'results',projectDate,subject);
    if opt.easyOnly
    fileName = ['pop_',opt.categoryName,'_easy.pdf'];
    elseif ~opt.doStops
    fileName = ['pop_',opt.categoryName,'_go.pdf'];
    else
    fileName = ['pop_',opt.categoryName,'.pdf'];
    end
    print(figureHandle, fullfile(filePath, fileName), '-dpdf', '-r300')
end
return

% ________________________________________________________________________________
% ________________________________________________________________________________
% ________________________________________________________________________________
% ________________________________________________________________________________
% ________________________________________________________________________________



