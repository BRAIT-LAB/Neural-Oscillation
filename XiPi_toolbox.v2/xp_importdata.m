function XiPi = xp_importdata()
    % use EEGLAB import set function.
    EEG = pop_loadset();

    % new struct
    XiPi = struct();

    XiPi.filename = EEG.filename;
    XiPi.filepath = EEG.filepath;
    XiPi.nbchan = EEG.nbchan;
    XiPi.srate = EEG.srate;
    XiPi.data = EEG.data;
    XiPi.spectra = [];
    XiPi.parameters = struct;
    XiPi.history = struct;
    XiPi.separate = struct;
    
    % write history
    insertLoc = length(fieldnames(XiPi.history)) + 1;
    XiPi.history.("history_" + num2str(insertLoc)) = 'importdata';
end


