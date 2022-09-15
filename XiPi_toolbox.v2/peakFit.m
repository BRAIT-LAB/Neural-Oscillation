function [fitresult, gof] = peakFit(freq, datalog, peakEquation)

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( freq, datalog );

% Set up fittype and options.
ft = fittype( peakEquation, 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );


