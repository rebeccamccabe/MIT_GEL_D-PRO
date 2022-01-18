function [fanP,fanQ] = fan_curve(which_fan,num_fans,fans_series)
    if which_fan == 1
        % A14 2000 rpm
        % m3/hr converted to CFM
        fanQ = [182.5 138.1 93.5 42.7 0]*.5886;
        % mm water converter to Pa
        fanP = [0.0 1.21 1.74 3.17 4.18]*9.807;
    elseif which_fan == 2
        fanP = [100 0];
        fanQ = [0 30];
    elseif which_fan == 3
        fanP = [80 0];
        fanQ = [0 30];
    end
    
    if fans_series
        fanP = fanP * num_fans;
    else
        fanQ = fanQ * num_fans;
    end
end