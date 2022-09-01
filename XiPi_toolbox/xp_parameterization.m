% 成分参数化类
classdef xp_parameterization < handle
    properties
        xi
        pi
        xi_parameters = [];
        pi_parameters = [];
    end

    methods  % object function
        function para = xp_parameterization(sep)
            % 对当前属性赋值
            para.pi = sep.xi;
            para.pi = sep.pi;
        end
    end

    methods(Access = protected) % extension functions
        function  parameterization(para)
            para.xi_parameters = [1];
            para.pi_parameters = [1];
            return
        end
    end
end