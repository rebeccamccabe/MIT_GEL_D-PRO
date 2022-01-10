%% Enter your design information here
CFM = 12.5; % flow rate [ft^3/min]
N_cells = 80; % number of fin cells on chosen PTC heater [-]
V_air = .13; % air volume not including cabin [m^3]

%% No need to change anything below this line
p = struct( ...  % constant parameters
            'h_amb',0.23,...                % heat transfer coeff to ambient [W / (m^2 degC)]
            'A_amb',3.4,...                 % area for heat transfer to ambient [m^2]
            'A_frac',0.5,...                % fraction of the above area between heater and sensor [-]
            'h_heater',10,...               % heat transfer coeff of heater [W / (m^2 degC)]
            'A_heater',300e-6*N_cells,...   % area for heat transfer by heater [m^2]
            'm_dot',1.2*CFM*472e-6,...      % mass flow rate [m^3/s]
            'cp',1000,...                   % specific heat at const pressure of air [J/(kg degC)]
            'cv',718,...                    % specific heat at const volume of air [J/(kg degC)]
            'T_amb',22,...                  % ambient temp [degC]
            'rho',1.2,...                   % density of air [kg/m^3]
            'V',0.42+V_air,...              % volume of air [m^3]
            'T_s',150,...                   % surface temp of heater [degC]
            'eps',0.03,...                  % emissivity of heater [-]
            'sigma',5.67e-8 ...             % Stefan-Boltzmann constant [W / (m^2 K^4)]
        );

tf = 10*60; % 10 minute simulation
T0 = 22.4 * [1 1 1]; % initial temps
func = @(t,T,dTdt)thermals(t,T,dTdt,p); % ode function
dTdt0 = decic(func,0,T0,[1 0 0],[.001 .001 .001],[0 0 0]); % initial temp derivatives

sol = ode15i(func, [0 tf], T0, dTdt0); % solve ode
tout = 0:30:tf;
[Tout,dTdtout] = deval(sol,tout);
[~,Qdot_conv,Qdot_rad,Qdot_tot] = thermals(tout,Tout,dTdtout,p);

figure
subplot 121
plot(tout/60,Tout)
hold on
plot(tout/60,22.4+(24.8-22.4)*(1-exp(-tout/(9*60))),'k--');
legend('T_{out}','T_{in}','T_{sens}','T_{sens} Measured')
xlabel('Time (min)')
ylabel('Temp (degC)')
grid on
subplot 122
plot(tout/60,Qdot_conv,tout/60,Qdot_rad,tout/60,Qdot_tot)
legend('Convection','Radiation','Total')
xlabel('Time (min)')
ylabel('Power (W)')
grid on

function [err,Qdot_conv,Qdot_rad,Qdot_tot] = thermals(t,T,dTdt,p)

    err = zeros(3,length(t));
    T_out = T(1,:);
    T_in = T(2,:);
    T_sens = T(3,:);
    T_avg = 1/2 * (T_out + T_in);
    dTdt_avg = 1/2 * (dTdt(1,:) + dTdt(2,:));

    % first equation: heat transfer to ambient, around whole loop
    tau = p.rho * p.V * p.cv / (p.m_dot * p.cp);
    T_ratio = (T_out - p.T_amb)/(T_in - p.T_amb);
    exponent = p.h_amb * p.A_amb / (p.m_dot * p.cp) * (1 - exp(-t/tau));
    err(1,:) = T_ratio - exp(exponent);

    % second equation: heat provided by heater
    Qdot_conv = p.h_heater * p.A_heater * (p.T_s - T_avg);
    Qdot_rad = p.eps * p.sigma * ((p.T_s + 273).^4 - (T_avg + 273).^4);
    Qdot_tot = p.m_dot * p.cp * (T_out - T_in) + p.rho * p.V * p.cv * dTdt_avg;
    err(2,:) = Qdot_tot - (Qdot_conv + Qdot_rad);

    % third equation: heat transfer to ambient, from heater to sensor only
    T_ratio_sens = (T_out - p.T_amb)/(T_sens - p.T_amb);
    exponent_sens = exponent * p.A_frac;
    err(3,:) = T_ratio_sens - exp(exponent_sens);

end