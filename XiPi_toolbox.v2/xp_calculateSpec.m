function XiPi = xp_calculateSpec(XiPi,time_range,limited_freq,varargin)
    % init XiPi.spectra
    XiPi.spectra = [];
    
    % acq parameters
    input = inputParser();
    input.addParameter('select_chan',1:XiPi.nbchan);
    input.addParameter('window_size',XiPi.srate,@isscalar);
    input.addParameter('overlapping',XiPi.srate/2,@isscalar);
    input.addParameter('freqResolution',0.5,@isscalar);
    input.parse(varargin{:});

    select_chan = input.Results.select_chan;
    window_size = input.Results.window_size;
    overlapping = input.Results.overlapping;
    freqResolution = input.Results.freqResolution;

    % default paras
    if isempty(XiPi)
        error('Import data first, and init XiPi struct')
    end

    if isempty(time_range)
        time_range = [0 size(XiPi.data,2) / XiPi.srate];
    end
    if isempty(limited_freq)
        if XiPi.srate > 100
            limited_freq = 50;
        else 
            error('Limited_freq is neccessary');
        end
    end

    % calculate specdata - pwelch
    startTime = time_range(1);
    endTime = time_range(2);
    data = XiPi.data(select_chan,startTime * XiPi.srate + 1: endTime* XiPi.srate);
    [pxx,f] = pwelch(data',hanning(window_size),overlapping,XiPi.srate / freqResolution,XiPi.srate);
    spectra = pxx';
    freq = f';
    XiPi.freq = freq(2:limited_freq / freqResolution + 1);
    XiPi.spectra = spectra(:,2:limited_freq / freqResolution + 1);

    % notify
    disp('success! see XiPi.spectra for results')
    
    % write history
    insertLoc = length(fieldnames(XiPi.history)) + 1;
    XiPi.history.("history_" + num2str(insertLoc)) = 'calculate spectra';
end