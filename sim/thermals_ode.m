function [time,power] = thermals_ode(CFM, N_cells, m_heater)

close all
%% Enter your design information here
%CFM = 10;       % flow rate [ft^3/min]
%N_cells = 40;   % number of fin cells on chosen PTC heater [-]
V_air = .15;    % air volume not including cabin [m^3]
mdot_frac = .1; % fraction of air heated (set this = 1 if the heater is not bypassed)
%m_heater = 0.05;% mass of active elements of chosen PTC heater [kg]
A_frac = 0.5;   % fraction of the ambient heat transfer area between heater and sensor [-]

%% No need to change anything below this line
p = struct( ...  % constant parameters
            'V',0.42+V_air,...              % volume of air [m^3] 
            'R0',0.56,...                   % PTC resistance at T=0 degC [Ohms]
            'RT',1.025,...                  % PTC resistance exponent base [Ohms^(1/degC)]
            'h_amb',0.1,...                 % heat transfer coeff to ambient [W / (m^2 degC)]
            'A_amb',3.4,...                 % area for heat transfer to ambient [m^2]
            'A_frac',A_frac,...             % fraction of the ambient heat transfer area between heater and sensor [-]
            'h_heater',5,...                % heat transfer coeff of heater [W / (m^2 degC)]
            'A_heater',300e-6*N_cells,...   % area for heat transfer by heater [m^2]
            'm_heater',m_heater,...         % mass of active elements of chosen PTC heater [kg]           
            'mdot_frac',mdot_frac,...       % fraction of air heated [-]
            'eps',0.1,...                   % emissivity of heater [-]
            'c_heater',900,...              % specific heat of aluminum
            'm_dot',1.2*CFM*472e-6*mdot_frac,...% mass flow rate [m^3/s]
            'cp',1000,...                   % specific heat at const pressure of air [J/(kg degC)]
            'cv',718,...                    % specific heat at const volume of air [J/(kg degC)]
            'T_amb',22,...                  % ambient temp [degC]
            'rho',1.2,...                   % density of air [kg/m^3]                      
            'sigma',5.67e-8,...             % Stefan-Boltzmann constant [W / (m^2 K^4)]
            'voltage',12 ...                % DC voltage [V]           
        );
            %'T_s',150,...                   % surface temp of heater [degC]

tf = 10*60; % 10 minute simulation
T0 = 22.4 * [1 1 1 1]; % initial temps
func = @(t,T,dTdt)thermals(t,T,dTdt,p); % ode function
dTdt0 = decic(func,0,T0,[1 0 0 0],[.001 .001 .001 .001],[0 0 0 0]); % initial temp derivatives

sol = ode15i(func, [0 tf], T0, dTdt0); % solve ode
tout = 0:15:tf;
[Tout,dTdtout] = deval(sol,tout);
[~,Qdot_conv,Qdot_rad,Qdot_heat,Qdot_elec] = thermals(tout,Tout,dTdtout,p);

% figure
% subplot 121
% plot(tout/60,Tout)
% hold on
% legend('T_{out}','T_{in}','T_{sens}','T_s')
% xlabel('Time (min)')
% ylabel('Temp (degC)')
% grid on
% subplot 122
% plot(tout/60,Qdot_conv,tout/60,Qdot_rad,tout/60,Qdot_heat,tout/60,Qdot_elec)
% hold on
% legend('Convection','Radiation','Heater Warm-up','Total Electrical')
% xlabel('Time (min)')
% ylabel('Power (W)')
% grid on
% improvePlot

% extract time to achieve 1 degC temp rise
idx = find(Tout(3,:) > (T0(3) + 1),1);
time = tout(idx);
power = Qdot_elec(end);

end

function [err,Qdot_conv,Qdot_rad,Qdot_heat,Qdot_elec] = thermals(t,T,dTdt,p)

    err = zeros(3,length(t));
    T_out_unmixed = T(1,:);
    T_in = T(2,:);
    T_out_mixed = T_out_unmixed * p.mdot_frac + T_in * (1-p.mdot_frac);
    T_sens = T(3,:);
    T_s = T(4,:);
    T_avg = 1/2 * (T_out_unmixed + T_in);
    dTdt_avg = 1/2 * (dTdt(1,:) + dTdt(2,:));

    % first equation: heat transfer to ambient, around whole loop
    tau = p.rho * p.V * p.cv / (p.m_dot * p.cp);
    T_ratio = (T_out_mixed - p.T_amb)/(T_in - p.T_amb);
    exponent = p.h_amb * p.A_amb / (p.m_dot * p.cp) * (1 - exp(-t/tau));
    err(1,:) = T_ratio - exp(exponent);

    % second equation: heat provided by heater
    Qdot_conv = p.h_heater * p.A_heater * (T_s - T_avg);
    Qdot_rad = p.A_heater * p.eps * p.sigma * ((T_s + 273).^4 - (T_avg + 273).^4);
    Qdot_tot = p.m_dot * p.cp * (T_out_unmixed - T_in) + p.rho * p.V * p.cv * dTdt_avg;
    err(2,:) = Qdot_tot - (Qdot_conv + Qdot_rad);

    % third equation: heat transfer to ambient, from heater to sensor only
    T_ratio_sens = (T_out_mixed - p.T_amb)/(T_sens - p.T_amb);
    exponent_sens = exponent * p.A_frac;
    err(3,:) = T_ratio_sens - exp(exponent_sens);
    
    % fourth equation: temperature rise of the heater element
    dTsdt = dTdt(4,:);
    R = p.R0 * p.RT.^T_s;
    Qdot_elec = p.voltage^2 ./ R;
    Qdot_heat = p.m_heater * p.c_heater * dTsdt;
    err(4,:) = Qdot_elec - Qdot_tot - Qdot_heat;

end