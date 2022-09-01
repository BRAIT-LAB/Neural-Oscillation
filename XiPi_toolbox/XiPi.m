% 初始化类
classdef XiPi < handle
    properties
        time_series
        channel_number
        freq
        spectra
        sample
    end

    properties(Access = protected)
        preprocess
        separate
        plot
    end

    methods  % public paras
        function xp = XiPi(varargin)
            input = inputParser();
            input.addParameter('time_series', []);
            input.addParameter('spectra', []);
            input.addParameter('freq', []);
            input.addParameter('channel_number', [],@isscalar);
            input.addParameter('sample',[] , @isscalar);
            input.parse(varargin{:});

            xp.time_series = input.Results.time_series;
            xp.channel_number = input.Results.channel_number;
            xp.freq = input.Results.freq;
            xp.spectra = input.Results.spectra;
            xp.sample = input.Results.sample;
            
            if isempty(xp.time_series) && isempty(xp.spectra)
                error('ERROR: The time_series and spectral can be empty at the same time')
            end

            if isempty(xp.sample)
                xp.sample = 200;
                warning('WARNNING: The sample is empty and set as default 200 Hz')
            end

            if isempty(xp.channel_number)
                xp.channel_number = min([size(time_series,1) size(time_series,2)]);
                warning(['WARNNING: The channel number is empty and set as ', xp.channel_number])
            end
            
            % time_series' row as channels
            if ~isempty(xp.channel_number) && ~isempty(xp.time_series)
                if xp.channel_number == size(xp.time_series,1)
                else
                    if xp.channel_number == size(xp.time_series,2)
                        xp.time_series = xp.time_series';
                    else
                        error('ERROR: The channel_number is not matched to spectra')
                    end
                end
            end

            % time_series' row as channels
            if ~isempty(xp.channel_number) && ~isempty(xp.spectra)
                if xp.channel_number == size(xp.spectra,1)
                else
                    if xp.channel_number == size(xp.spectra,2)
                        xp.spectra = xp.spectra';
                    else
                        error('ERROR: The channel_number is not matched to spectra')
                    end
                end
            end
        end
    end

    methods  % protected paras
        function pre = startPreprocess(xp)
            assert(~isempty(xp.time_series),'ERROR: Time seires can not be empty when start Preprocessing')
            pre = xp_preprocess(xp);
            xp.preprocess = pre;
        end

        function p = startPlot(xp)
            p = xp_plot(xp);
            xp.plot = p;
        end

        function sep = startSeparate(xp)
            assert(~isempty(xp.spectra) | ~isempty(xp.freq),'Freq or Spectra can not be empty')
            sep = xp_separate(xp);
            xp.separate = sep;
        end
    end
    
    methods  % extension methods
        % plot
        function plt_timeseries()
        end

        function plt_spectra
        end
    end
end
