
function [flow,fan_power] = pipe_flow(fanP,fanQ,k_filter,p)

fun = @(cfm) deltaP(cfm,fanP,fanQ,k_filter,p);
flow = fminbnd(fun,0,max(fanQ));
[~,P_fan] = deltaP(flow,fanP,fanQ,k_filter,p);
Q_fan = flow / .5886 * 3600; % m^3/s
fan_power = P_fan * Q_fan;

end

function [dP,P_fan] = deltaP(cfm,fanP,fanQ,k_filter,p)
    P_fan = interp1(fanQ,fanP,cfm);
    P_filter = cfm^2 * k_filter;
    
    f = 0.01; L = 1; D = 0.1; k_minor = 1.5; Cd = 2; rho = 1.2; % hardcode for now
    [v_duct,v_heater,v_enclosure,v_cabin] = deal(cfm / 40); % hack
    
    P_dyn_duct = .5 * rho * v_duct^2;
    P_dyn_heater = .5 * rho * v_heater^2;
    P_dyn_enclosure = .5 * rho * v_enclosure^2;
    P_dyn_cabin = .5 * rho * v_cabin^2;
    
    P_duct = (f * L/D + k_minor) * P_dyn_duct;
    P_heater = (f * L/D + k_minor) * P_dyn_heater;
    P_enclosure = (f * L/D + k_minor) * P_dyn_enclosure;
    P_cabin = (f * L/D + k_minor + Cd) * P_dyn_cabin;
    dP = P_fan - (P_filter + P_duct + P_heater + P_enclosure + P_cabin);
    dP = abs(dP);
end
