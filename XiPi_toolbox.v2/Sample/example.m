% load data, need eeglab support
XiPi = xp_importdata();

% preprocessing ...

% calculateSpec
XiPi = xp_calculateSpec(XiPi,[0 54],50,'select_chan',[1 2]);

% separateSepc
XiPi = xp_separateSepc(XiPi);

% plot
XiPi = xp_plot(XiPi,[1 2]);

% parameterization
XiPi = xp_parameterize(XiPi);