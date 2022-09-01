% 谱分解类 ***
classdef xp_separate < handle
    properties
        freq
        spectra
        xi
        pi
        psd_ftd
    end

    properties(Access = protected)
        parameterization
    end

    methods  % Object function
        function sep = xp_separate(xp)
            sep.freq = xp.freq;
            sep.spectra = xp.spectra;
        end
    end
    
    methods % children function
        function sep = startParameterization(sep)
            para = xp_parameterization(sep);
            sep.parameterization = para;
        end
    end

    methods  % extension functions
        function spectra_separate(sep)
            % 计算xi pi， 为xi pi赋值
            sep.xi = [];
            sep.pi = [];
            sep.psd_ftd = [];
        end

        function plt_components()
        end
    end
end