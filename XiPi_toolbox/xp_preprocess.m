% 预处理类
classdef xp_preprocess < handle
    properties
        time_series
        freq
        spectra
        sample
    end

    properties(Access = protected)
        separate
    end

    methods % object function
        function pre = xp_preprocess(xp)
            pre.time_series = xp.time_series;
            pre.freq = xp.freq;
            pre.sample = xp.sample;
        end
    end
    
    methods % children object function
        function sep = startSeparate(pre)
            assert(~isempty(pre.spectra),['Spectra can not be empty'])
            sep = xp_separate(pre);
            pre.separate = sep;
        end
    end

    methods % extension functions
        % Filter

        % re-reference
        function re_reference(pre)
            % 对时间序列重新赋值
            pre.time_series = [1 2 3 4];
        end

        % re-sample

        % spectrum analysis
        function calculate_spectral(pre,varargin)
            % calculate spectra
           
            input = inputParser();
            input.addParameter('hanningSize', [],@isscalar);
            input.addParameter('overlapping', [],@isscalar);
            input.addParameter('freqResolution', [],@isscalar);
            input.addParameter('freqRange',[])
            input.parse(varargin{:});
            
            hanningSize = input.Results.hanningSize;
            overlapping = input.Results.overlapping;
            freqResolution = input.Results.freqResolution;
            freqRange = input.Results.freqRange;
            if isempty(hanningSize)
                hanningSize = pre.sample;
                warning('WARNING: The hanningSize is isempty, set to defalut 1 * sample');
            end
            if isempty(overlapping)
                overlapping = pre.sample / 2;
                warning('WARNING: The overlapping is isempty, set to defalut 50% * sample');
            end
            if isempty(freqResolution)
                freqResolution = 0.5;
                warning('WARNING: The overlapping is isempty, set to defalut 0.5');
            end
            if isempty(freqRange)
                freqRange = [0.5 50];
                warning('WARNING: The overlapping is isempty, set to defalut [0 50]');
            end
            
            [pxx,f] = pwelch(pre.time_series',hamming(hanningSize),overlapping,pre.sample / freqResolution,pre.sample);
            pre.spectra = pxx';
            pre.freq = f';

            startP = freqRange(1) / freqResolution + 1;
            endP = freqRange(2) / freqResolution + 1;
            % Ensure the startPoint starts from the second freqPoint
            if startP == 1
                startP = 2;
            end

            pre.spectra = pre.spectra(:,startP : endP);
            pre.freq = pre.freq(:,startP : endP);
        end



        % plot
        function plt_timeseries(pre)
            plot(pre.time_series);
        end

        function plt_spectra(pre,varargin)
            if isempty(pre.spectra)
                error('ERROR: Please caculate spectra first');
            end
            input = inputParser();
            input.addParameter('scale','logarithmic',@ischar);
            input.parse(varargin{:});

            scale = input.Results.scale;
            if strcmp(scale,'logarithmic')
                for i = 1 : size(pre.spectra,1)
                    plot(pre.freq,10*log10(pre.spectra(i,:)),'LineWidth',2,'DisplayName',['spectrum_',num2str(i)])
                    hold on
                end
                legend
                xlabel('Frequency(Hz)')
                ylabel('10*log10(uv²/Hz)')
            else
                for i = 1 : size(pre.spectra,1)
                    plot(pre.freq,pre.spectra(i,:),'LineWidth',2,'DisplayName',['spectrum_',num2str(i)])
                    hold on
                end
                legend
                xlabel('Frequency(Hz)')
                ylabel('uv²/Hz')
            end
        end
    end
end