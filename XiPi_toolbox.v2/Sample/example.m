% EEGLAB preprocessing ...

% load data, need eeglab support
XiPi = xp_importdata([]);clearvars -except XiPi

% calculateSpec
XiPi = xp_calculateSpec(XiPi,[],50);

% separateSepc
XiPi = xp_separateSepc(XiPi);

% plot
% XiPi = xp_plot(XiPi,1:100);

% parameterization
XiPi = xp_parameterize(XiPi);

