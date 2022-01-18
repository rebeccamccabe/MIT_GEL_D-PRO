
function [flow,fan_power] = pipe_flow(fanP,fanQ,k_filter,N_cells,p)

% solve for flow
fun = @(cfm) deltaP(cfm,fanP,fanQ,k_filter,N_cells,p);
flow = fminbnd(fun,0,max(fanQ));

% plug solution back in
[~,P_fan] = deltaP(flow,fanP,fanQ,k_filter,N_cells,p);
Q_fan = flow / (.5886 * 3600); % cfm to m^3/s
fan_power = P_fan * Q_fan;

end

function [dP,P_fan] = deltaP(cfm,fanP,fanQ,k_filter,N_cells,p)
    P_fan = interp1(fanQ,fanP,cfm);
    P_filter = cfm^2 * k_filter;
    
    Ls = [p.L_duct,p.L_heater,p.L_enclosure,p.L_cabin];
    diams = [p.D_duct,p.D_heater,p.D_enclosure,p.D_cabin];
    k_minors = [p.k_minor_duct,p.k_minor_heater,p.k_minor_enclosure,p.k_minor_cabin];
    Cds = [0 0 0 p.Cd];
    eps = [p.eps_duct,p.eps_heater,p.eps_enclosure,p.eps_cabin];
    
    areas = pi/4 * diams.^2;
    vels = cfm / (.5886 * 3600) ./ areas;
    vels(2) = vels(2) / N_cells; % heater flow splits, this assumes no bypass and that multiple heaters are in parallel
    Re = p.rho * vels .* diams / p.nu;
    
    if Re < 4000
        f = 64 ./ Re;
    else
        f = (-1.8 * log10(6.9 ./ Re + (eps./diams/3.7).^1.11)).^-2;
    end
    
    P_dyn = .5 * p.rho * vels.^2;
    P_drop = (f .* Ls./diams + k_minors + Cds) .* P_dyn;
    
    dP = P_fan - (P_filter + sum(P_drop));
    dP = abs(dP);
end
