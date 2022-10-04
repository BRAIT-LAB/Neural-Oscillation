function XiPi = xp_separateSepc(XiPi,varargin)
            % new saparate spectra struct
            XiPi.separate.xi = [];
            XiPi.separate.pi = struct;
            XiPi.separate.combining = [];
            
            input = inputParser();
            input.addParameter('chooseChannels', 1 : size(XiPi.spectra,1));
            input.addParameter('scale', 'natural',@ischar);
            input.parse(varargin{:});
            channels = input.Results.chooseChannels;
            scale = input.Results.scale;
            
            % separate spectra. natural
            if  strcmp(scale,'natural')
                for i = channels
                    try 
                    [overallfitting,components] = scmem_unim(XiPi.freq',XiPi.spectra(i,:)',[0 0 0]);
                    catch
                        XiPi.separate.xi = [XiPi.separate.xi;zeros(1,length(XiPi.freq))];
                        XiPi.separate.pi.("spectra_" + num2str(i)) = [];
                        XiPi.separate.combining = [XiPi.separate.combining;zeros(1,length(XiPi.freq))];
                    end
                    XiPi.separate.xi = [XiPi.separate.xi;components(:,1)'];
                    XiPi.separate.pi.("spectra_" + num2str(i)) = components(:,2:end)';
                    XiPi.separate.combining = [XiPi.separate.combining;overallfitting'];
                end
            end
            % separate spectra. log, scalp eeg
            if  strcmp(scale,'logarithm')
                for i = channels
                    try 
                    [overallfitting,components] = scmem_unim_log(XiPi.freq',log10(XiPi.spectra(i,:)'),[0 0 0]);
                    catch
                        XiPi.separate.xi = [XiPi.separate.xi;zeros(1,length(XiPi.freq))];
                        XiPi.separate.pi.("spectra_" + num2str(i)) = [];
                        XiPi.separate.combining = [XiPi.separate.combining;zeros(1,length(XiPi.freq))];
                    end
                    XiPi.separate.xi = [XiPi.separate.xi;components(:,1)'];
                    XiPi.separate.pi.("spectra_" + num2str(i)) = components(:,2:end)';
                    XiPi.separate.combining = [XiPi.separate.combining;overallfitting'];
                end
            end
            
            % notify
            disp('success! see XiPi.separate for results, you can parameterize the components through xp_parameterlize')
            
            % write history
            insertLoc = length(fieldnames(XiPi.history)) + 1;
            XiPi.history.("history_" + num2str(insertLoc)) = 'separate spectra';
            
end