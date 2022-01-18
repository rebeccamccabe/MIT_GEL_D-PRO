function [fanP,fanQ] = fan_curve(which_fan,num_fans,fans_series)
    if which_fan == 1
        % A20 800 rpm
        fanQ = [146.9 102.4 72.1 33.8 0]*.5886; % m3/hr converted to CFM
        fanP = [0 .36 .53 .79 1.08]*9.807;      % mm water converter to Pa
    elseif which_fan == 2
        % A14 2000 rpm
        fanQ = [182.5 138.1 93.5 42.7 0]*.5886; % m3/hr converted to CFM
        fanP = [0.0 1.21 1.74 3.17 4.18]*9.807; % mm water converter to Pa
    elseif which_fan == 3
        fanQ = [269.3 208.2 139.3 65.7 0]*.5886; % m3/hr converted to CFM
        fanP = [0 2.63 3.98 7.67 10.52]*9.807; % mm water converter to Pa        
    end
    
    if fans_series
        fanP = fanP * num_fans;
    else
        fanQ = fanQ * num_fans;
    end
end