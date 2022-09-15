% load data
EEG = pop_loadset();
data = EEG.data;

% 
time = data(1:15000);
[pxx,f] = pwelch(time',hanning(500),250,1000,500);
plot(f(2:91),pxx(2:91))