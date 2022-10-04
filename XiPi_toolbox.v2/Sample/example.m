% EEGLAB preprocessing ...

% load data, need eeglab support
XiPi = xp_importdata([]);

% calculateSpec
XiPi = xp_calculateSpec(XiPi,[],45,'select_chan',1:XiPi.nbchan);

% separateSepc
XiPi = xp_separateSepc(XiPi,'chooseChannels',16,'scale','logarithm');

% plot
XiPi = xp_plot(XiPi,[1 2]);

% parameterization
XiPi = xp_parameterize(XiPi);

