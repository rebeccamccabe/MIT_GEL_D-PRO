function h = heat_transfer_correlation(CFM,N_cells,p)
    area = pi/4 * p.D_heater^2;
    v = CFM / N_cells * 472e-6 * p.mdot_frac / area;
    
    Pr = p.mu * p.cp / p.k_air;
    Re = p.rho * v * p.D_heater / p.mu;
    D_L_Re_Pr = p.D_heater / p.L_heater * Re * Pr;
    
    % correlation for laminar flow in a pipe with constant wall temperature
    Nu = 3.66 + (0.065 * D_L_Re_Pr) / (1 + 0.04 * D_L_Re_Pr^(2/3));
    
    h = Nu * p.k_air / p.D_heater;

end