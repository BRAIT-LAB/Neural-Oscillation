%%
load LDA_results
% ldaClass = resubPredict(lda);
% ldaResubErr = resubLoss(lda);
mode = xipi;
% wake-N2 LDA 
lda = fitcdiscr(mode(1:74,1),species(1:74));
cp = cvpartition(species(1:74),'KFold',74);
cvlda = crossval(lda,'CVPartition',cp);
ldaCVErr = kfoldLoss(cvlda);

% wake-REM
lda = fitcdiscr([mode(1:37,1);mode(75:111,1)],[species(1:37);species(75:111)]);
cp = cvpartition([species(1:37);species(75:111)],'KFold',74);
cvlda = crossval(lda,'CVPartition',cp);
ldaCVErr = kfoldLoss(cvlda);

% N2-REM
lda = fitcdiscr(mode(38:111,1),species(38:111));
cp = cvpartition(species(38:111),'KFold',74);
cvlda = crossval(lda,'CVPartition',cp);
ldaCVErr = kfoldLoss(cvlda);


%% plot
X = categorical({'FOOOF exponent','XiPi exponent'});
X = reordercats(X,{'FOOOF exponent','XiPi exponent'});
% Y = [79.73 83.78];
Y = [90.54 98.65];
% Y = [62.16 71.62];
b = bar(X,Y,0.3)
b.FaceColor = 'flat';
b.CData(1,:) = [0 0.5 1];
b.CData(2,:) = [1 0.5 1];
hold on
title('Wake - REM')
% title('N2 - REM')
ylabel('LDA performance(%)')
plot(X,[50 50],'--')
ylim([0 100])