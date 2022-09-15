function XiPi_plot(f,original_spt,components)
    plot(f,original_spt,'linewidth',1.5);
    hold on
    for i=1:size(components,2)
        plot(f,components(:,i),'linewidth',1.5);
    end
    xlabel('frequency/Hz')
    ylabel('power')
    title('XiPi model')
end

