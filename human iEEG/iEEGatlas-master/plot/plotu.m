% plot goodness of fit
figure('name','goodness of fit'), plot(freq,[sigmav,psd]);legend({'Fit','Truth'});

% plot the trends of gradients varying 
figure('name','gradient varying trends'),
tl={'rou','mu','tau','nu'};
nc = size(U,1)/4;

for i=1:size(U,1)
    subplot(nc,4,i),
    plot(freq,U(i,:)'), title(tl{i-4*floor(i/4.1)});
    xlabel('Frequency');
    xlim([min(freq) max(freq)]);
end