load no_peak_time.mat

% simulation of aperiodic activity
aperiodic_activity = no_peak_time';

% simulation of periodic oscillations
fs = 200; N = 13600;
n=0:N-1; t = n/fs;
periodic_1 = 5*sin(2 * pi * 13 * t) + 6*sin(2 * pi * 15 * t)+5*sin(2 * pi * 30 * t); 
periodic_2 = 5*sin(2 * pi * 11 * t)+ 5*sin(2 * pi * 17 * t)+ 5*sin(2 * pi * 23 * t) + ...
5*sin(2 * pi * 26 * t)+ 5*sin(2 * pi * 29 * t)+5*sin(2 * pi * 32 * t) + ...
5*sin(2 * pi * 35 * t)+5*sin(2 * pi * 38 * t)+5*sin(2 * pi * 41 * t);

% combine signals
data = [aperiodic_activity + periodic_1;aperiodic_activity + periodic_2];

% init XiPi object
xipi = XiPi('time_series',data,'channel_number',size(data,1),'sample',fs);

% init preprocessing object
preprocess = xipi.startPreprocess();
preprocess.calculate_spectral() % ...
preprocess.plt_spectra('scale','natural');

% init separation object
separatation = preprocess.startSeparate();
% separate spectra into aperiodic and periodic oscillations.
separatation.spectra_separate();

% init parameterization object
paras = separatation.startParameterization();
paras.parameterization();