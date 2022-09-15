function [fitresult, gof] = apFit(freq, data, apEquation)

[xData, yData] = prepareCurveData( freq, data );

% Set up fittype and options.
ft = fittype( apEquation, 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

