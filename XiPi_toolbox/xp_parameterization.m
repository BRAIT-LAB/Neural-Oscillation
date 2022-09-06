% 成分参数化类
classdef xp_parameterization < handle
    properties
        freq
        xi
        pi
        xi_parameters = struct;
        pi_parameters = struct;
    end

    methods  % object function
        function para = xp_parameterization(sep)
            para.freq = sep.freq;
            para.xi = sep.xi;
            para.pi = sep.pi;
        end
    end

    methods % extension functions
        function  parameterization(para,varargin)
            input = inputParser();
            input.addParameter('apEquation','b - log10(x^a)',@ischar);
            input.addParameter('peakEquation','a1*exp(-((x-b1)/c1)^2)',@ischar);
            input.addParameter('scale','logarithm',@ischar);
            input.parse(varargin{:});
            apEquation = input.Results.apEquation;
            peakEquation = input.Results.peakEquation;
            scale = input.Results.scale;
           

            disp(['The apEquation is ',apEquation]);
            disp(['The peakEquation is ',peakEquation]);
            
            warning("off")
            for i = 1:size(para.xi,1)
                if strcmp(scale,'logarithm')
                    ap = apFit(para.freq, log10(para.xi(i,:)), apEquation);
                else
                    ap = apFit(para.freq, para.xi(i,:), apEquation);
                end
                
                para.xi_parameters.("paramter_" + num2str(i)) = ap;
            end

            peaks = fieldnames(para.pi);
            for i = 1 : length(peaks)
                currentPeak = peaks{i,1};
                parameter = struct;
                for j = 1 : size(para.pi.(currentPeak),1)
                    if strcmp(scale,'logarithm')
                        peak = peakFit(para.freq, log10(para.pi.(currentPeak)(j,:)), peakEquation);
                        parameter.("peak_" + num2str(j)) = peak;
                    else
                        peak = peakFit(para.freq, para.pi.(currentPeak)(j,:), peakEquation);
                    end
                end
                para.pi_parameters.("paramter_" + num2str(i)) = parameter;
            end
        end

        
    end
end