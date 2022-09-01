classdef xp_plot < handle
    properties
        time_series
        spectra
    end

    methods % object function
        function p = xp_plot(xp)
            p.time_series = xp.time_series;
        end
    end

    methods % extension functions

    end
end