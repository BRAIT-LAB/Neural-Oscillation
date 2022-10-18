% EEGLAB preprocessing ...


% load data, need eeglab support
XiPi = xp_importdata([]);

% calculateSpec
XiPi = xp_calculateSpec(XiPi,[],50);

% separateSepc
XiPi = xp_separateSepc(XiPi,'chooseChannels',[1 2]);

% plot
XiPi = xp_plot(XiPi,1:100);

% parameterization
XiPi = xp_parameterize(XiPi);

