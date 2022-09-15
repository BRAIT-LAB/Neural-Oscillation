function XiPi = xp_parameterize(XiPi,varargin)
    % new saparate spectra struct
    XiPi.paras.xi_paras = struct;
    XiPi.paras.pi_paras = struct;
    
    input = inputParser();
    input.addParameter('apEquation','b - log10(x^a)',@ischar);
    input.addParameter('peakEquation','a1*exp(-((x-b1)/c1)^2)',@ischar);
    input.addParameter('scale','logarithm',@ischar);
    input.parse(varargin{:});
    apEquation = input.Results.apEquation;
    peakEquation = input.Results.peakEquation;
    scale = input.Results.scale;

    disp(['The apEquation is ',apEquation]);
    disp(['The peakEquation is ',peakEquation]);warning("off")
    
    % parameterize
    for i = 1:size(XiPi.separate.xi,1)
        if strcmp(scale,'logarithm')
            ap = apFit(XiPi.freq, log10(XiPi.separate.xi(i,:)), apEquation);
        else
            ap = apFit(XiPi.freq, XiPi.separate.xi(i,:), apEquation);
        end

        XiPi.paras.xi_paras.("paramter_" + num2str(i)) = ap;
    end
    
    channels = fieldnames(XiPi.separate.pi);
    for i = 1 : length(channels)
        currentChannel = channels{i,1};
        parameter = struct;
        for j = 1 : size(XiPi.separate.pi.(currentChannel),1)
            if strcmp(scale,'logarithm')
                peak = peakFit(XiPi.freq, log10(XiPi.separate.pi.(currentChannel)(j,:)), peakEquation);
                parameter.("peak_" + num2str(j)) = peak;
            else
                peak = peakFit(para.freq, para.pi.(currentChannel)(j,:), peakEquation);
                parameter.("peak_" + num2str(j)) = peak;
            end
        end
        XiPi.paras.pi_paras.("channel_" + num2str(i)) = parameter;
    end
    
    % notify
    disp('success! see XiPi.parameters for results')
    warning("on")
    
    % write history
    insertLoc = length(fieldnames(XiPi.history)) + 1;
    XiPi.history.("history_" + num2str(insertLoc)) = 'parameterization';
end