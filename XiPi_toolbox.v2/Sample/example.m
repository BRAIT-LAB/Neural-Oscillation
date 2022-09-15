% load data, need eeglab support
XiPi = xp_importdata();

% preprocessing ...

% calculateSpec
XiPi = xp_calculateSpec(XiPi,[0 100],50,'select_chan',[1 2]);

% separateSepc
XiPi = xp_separateSepc(XiPi);

% parameterization
XiPi = xp_parameterize(XiPi);