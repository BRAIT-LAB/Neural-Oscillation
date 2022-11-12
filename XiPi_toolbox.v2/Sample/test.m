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
A = [5 8 11 14 17 20 23 26 29 32 35 38 41 44 47];

for i = 1:30
    ao = aperiodic_activity;
    po = zeros(1,13600);
    peakNum = randi([1 1],1,1);
    
    CF = A(randperm(numel(A),peakNum));
    PW = randi([11 15],1,peakNum);
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

%% 2022.10.8
% 模拟数据 大批量误差计算
% XiPi - pos mse
groudPi = pwelch(pos',hamming(200),100,400,200); 
groudPi = groudPi(2:101,:)';
MSEs = [];
for i = 1:100
    currentPi = XiPi.separate.pi.("spectra_" + num2str(i));
    sumPi = sum(currentPi,1);
    sub = sumPi - groudPi(i,:);
    err_mse = mse(sub);
    MSEs = [MSEs;err_mse];
end
% XiPi - ao
groudAO = pwelch(no_peak_time',hamming(200),100,400,200); 
groudAO = groudAO(2:101,:)';
AoMSEs = [];
for i = 1:100
    currentXi = XiPi.separate.xi(i,:);
    sub = currentXi - groudAO;
    err_mse = mse(sub);
    AoMSEs = [AoMSEs;err_mse];
end

% XiPi - nums
groudNum = peakNums;
fitNum = [];
for i = 1:100
    currentPi = XiPi.separate.pi.("spectra_" + num2str(i));
    if isempty(currentPi) 
        fitNum = [fitNum;0];
    else
        fitNum = [fitNum;size(currentPi,1)];
    end
end

% FOF - pos mse,ao,nums
settings = struct('peak_width_limits',[1 10]);
Nums = [];
AoMSEs = [];
correctAOMSEs = [];
PoMSEs = [];
for i = 1:100
    fooof_results = fooof(freq, spectra(i,:),[0 50], settings, 1);
    ao_fit = 10.^fooof_results.ap_fit;
    po_fit = 10.^fooof_results.fooofed_spectrum - 10.^fooof_results.ap_fit;
    
    sub = po_fit - groudPi(i,:);
    PoMSE = mse(sub);
    PoMSEs = [PoMSEs;PoMSE];
    
    sub = ao_fit - groudXi;
    AoMSE = mse(sub);
    AoMSEs = [AoMSEs;AoMSE];
    correct = sub(3:end);
    correct = mse(correct);
    correctAOMSEs = [correctAOMSEs;correct];
    
    Num = size(fooof_results.peak_params,1);
    Nums = [Nums;Num];
end

% plot
% bubble - XiPi nums
t = tiledlayout(1,1);
nexttile
x = [0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 5];
y = [0:5,0:5,0:5,0:5,0:5,0:5];
sz = zeros(1,36);
for i = 1:100
    a = peakNums(i);
    b = fitNum(i);
    sz(1,6*a+b+1) = sz(1,6*a+b+1) + 1;
end
bubblechart(x,y,sz,sz,'MarkerFaceAlpha',0.6,'MarkerFaceColor','red','MarkerEdgeColor','none');

hold on

% bubble - FOF nums
x = [0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 5];
y = [0:5,0:5,0:5,0:5,0:5,0:5];
sz = zeros(1,36);
for i = 1:100
    a = peakNums(i);
    b = Nums(i);
    sz(1,6*a+b+1) = sz(1,6*a+b+1) + 1;
end
map = colormap(summer(10000));
bubblechart(x,y,sz,sz,'MarkerFaceAlpha',0.4,'MarkerFaceColor','blue','MarkerEdgeColor','none');


blgd = bubblelegend('SampleNums');
lgd = legend('XiPi fit','FOOOF fit');
blgd.Layout.Tile = 'east';
lgd.Layout.Tile = 'east';
title('The comparison of peaks number')
xlabel('Number of simulated peaks')
ylabel('Number of fit peaks')

% boxplot
X = {'XiPi','FOOOF'};
box_figure = boxplot([log(a),log(b)],'color',[0 0 0],'Symbol','');
set(box_figure,'Linewidth',1.2)
boxobj = findobj(gca,'Tag','Box');
mycolor3 = [0.86,0.82,0.11;...
    0.23,0.49,0.71];
for i = 1:2
    patch(get(boxobj(i), 'XData' ),get(boxobj(i), 'YData' ),mycolor3(i,:),'FaceAlpha' ,0.5,'LineWidth',1.1);
end
hold on

set(gca,'Xticklabel',X)

%% real data
XiPi = xp_importdata([]);

% calculateSpec
XiPi = xp_calculateSpec(XiPi,[],50,'select_chan',1:XiPi.nbchan);

% separateSepc
XiPi = xp_separateSepc(XiPi,'chooseChannels',16,'scale','logarithm');

% plot
XiPi = xp_plot(XiPi,[1 2]);

%% 2022.10.13
% f向量
freq = 0.5:0.5:50;
figure
hold on
for i = 1:100
    b = bar(freq(i),w(i));
    set(b,'facecolor',color(flag(i),:))
end
