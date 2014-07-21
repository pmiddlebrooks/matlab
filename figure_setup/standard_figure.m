function [axisWidth, axisHeight, xAxesPosition, yAxesPosition] = standard_figure(nRow, nColumn, figureHandle)

set(0, 'units', 'centimeters')
scrsz = get(0,'ScreenSize');

switch get_environment
    case 'work'
        % standard letter paper size
        cmWidth = 21.6;
        cmHeight = 27.9;        
    case 'home'
        scaleFactor = .8;
        cmHeight = scrsz(4) * scaleFactor;
        squareAxes = false;
        if squareAxes
            cmWidth = cmHeight;
        else
            cmWidth = scrsz(3) * scaleFactor;
        end
end

sumFig = figure(figureHandle);
clf


interSpaceX = 1;
interSpaceY = 1.5;
leftRightMargin = 1.5;
topBottomMargin = 1.5;


axisWidth = (cmWidth - 2*leftRightMargin - interSpaceX * (nColumn-1)) / nColumn;
axisHeight = (cmHeight - 2*topBottomMargin - interSpaceY * (nRow - 1)) / nRow;



screenH = scrsz(4);
screenW = scrsz(3);
w = screenW;
h = screenH;


% figureHandle = 78;
% sumFig = figure(figureHandle);
% clf


xAxesPosition = nan(nRow, nColumn);
yAxesPosition = nan(nRow, nColumn);
for iRow = 1 : nRow
    for iCol = 1 : nColumn
        xAxesPosition(iRow, iCol) = leftRightMargin + axisWidth*(iCol-1) + interSpaceX*(iCol - 1);
        yAxesPosition(iRow, iCol) = cmHeight - (topBottomMargin + axisHeight*iRow + interSpaceY*(iRow - 1));
    end
end

set(sumFig, 'units', 'centimeters','position', [w/3 h/3 cmWidth cmHeight], 'paperunits', 'centimeters', 'paperposition', [0 0 cmWidth cmHeight], 'color', [1 1 1])

