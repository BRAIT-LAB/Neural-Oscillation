clean; close;
% simulated data
load no_peak_time.mat

% simulation of aperiodic activity
aperiodic_activity = no_peak_time';

% add periodic osillations. 
fs = 200; N = 13600;
n=0:N-1; t = n/fs;

combines = [];
pos = [];
peakNums = zeros(1,100);


for i = 1:100
ao = aperiodic_activity;
po = zeros(1,13600);
peakNum = randi([1 5],1,1);
CF = randi([2 50],1,peakNum);
PW = randi([5 10],1,peakNum);
    for j = 1:peakNum
        po = po + PW(j) * sin(2 * pi * CF(j) * t);
    end
combine = ao + po;
pos = [pos;po];
peakNums(i) = peakNum;

combines = [combines;combine];
end

% ao  pos(sum)  peakNum peakLocation
% for i = 1:100
% [pxx2,f] = pwelch(combines(3,:),hamming(200),100,400,200); 
% plot(f(2:100),pxx2(2:100))
% 
% end