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
        function calculate(pre)
            % 计算spectra
            pre.spectra = [];
        end



        % plot
        function plt_timeseries()
        end

        function plt_spectra
        end
    end
end