% 谱分解类 ***
classdef xp_separate < handle
    properties
        freq
        spectra
        xi
        pi = struct;
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
        function para = startParameterization(sep)
            if isempty(sep.xi)|| isempty(sep.pi) 
                error('Please run the spectra_separate function');
            end
            para = xp_parameterization(sep);
            sep.parameterization = para;
        end
    end

    methods  % extension functions
        function spectra_separate(sep,varargin)
            % 计算xi pi， 为xi pi赋值
            input = inputParser();
            input.addParameter('chooseChannels', 1 : size(sep.spectra,1));
            input.addParameter('scale', 'natural',@ischar);
            input.parse(varargin{:});
            channels = input.Results.chooseChannels;
            scale = input.Results.scale;

            if  strcmp(scale,'natural')
                for i = channels
                    [overfitting,components] = scmem_unim(sep.freq',sep.spectra(i,:)',[0 0 0]);
                    sep.xi = [sep.xi;components(:,1)'];
                    sep.pi.("speactra_" + num2str(i)) = components(:,2:end)';
                    sep.psd_ftd = [sep.psd_ftd;overfitting'];
                end
            end

%             if  strcmp(sclae,'logarithmic')
%                 for i = channels
%                     [overfitting,components] = scmem_unim_log(sep.freq',sep.spectra(i,:)',[0 0 0]);
%                     sep.xi = [sep.xi;components(1,:)];
%                     sep.pi.("speactra" + num2str(i)) = components(2:end,:);
%                     sep.psd_ftd = [sep.psd_ftd;overfitting];
%                 end
%             end
        end

        function plt_components()

        end
    end
end