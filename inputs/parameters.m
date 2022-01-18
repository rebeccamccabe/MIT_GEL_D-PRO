function p = parameters()
%% thermals
V_air = .15;    % air volume not including cabin [m^3]
mdot_frac = .1; % fraction of air heated [-] (set this = 1 if the heater is not bypassed)
A_frac = 0.5;   % fraction of the ambient heat transfer area between heater and sensor [-]

p = struct( ...  % constant parameters
            'A_fin',300e-6,...              % cross sectional area of a single fin [m^2]
            'V',0.42+V_air,...              % volume of air [m^3] 
            'R0',0.56,...                   % PTC resistance at T=0 degC [Ohms]
            'RT',1.025,...                  % PTC resistance exponent base [Ohms^(1/degC)]
            'h_amb',0.1,...                 % heat transfer coeff to ambient [W / (m^2 degC)]
            'A_amb',3.4,...                 % area for heat transfer to ambient [m^2]
            'A_frac',A_frac,...             % fraction of the ambient heat transfer area between heater and sensor [-]
            'h_heater',5,...                % heat transfer coeff of heater [W / (m^2 degC)]        
            'mdot_frac',mdot_frac,...       % fraction of air heated [-]
            'eps',0.1,...                   % emissivity of heater [-]
            'c_heater',900,...              % specific heat of aluminum
            'cp',1000,...                   % specific heat at const pressure of air [J/(kg degC)]
            'cv',718,...                    % specific heat at const volume of air [J/(kg degC)]
            'T_amb',22,...                  % ambient temp [degC]
            'rho',1.2,...                   % density of air [kg/m^3]                      
            'sigma',5.67e-8,...             % Stefan-Boltzmann constant [W / (m^2 K^4)]
            'voltage',12 ...                % DC voltage [V]           
        );

%% pipe flow
p.L_duct = 2;           % m
p.L_heater = 0.02;      % m
p.L_enclosure = 0.5;    % m
p.L_cabin = 1;          % m

p.D_duct = 0.1;         % m
p.D_heater = 0.005;     % m
p.D_enclosure = 0.1;    % m
p.D_cabin = 0.7;        % m

p.k_minor_duct = 2;     % - 
p.k_minor_heater = 2;   % -
p.k_minor_enclosure = 2;% -
p.k_minor_cabin = 2;    % -

p.rho = 1.2;            % density of air [kg/m^3]
p.nu = 18.3e-6;         % dynamic viscosity of air [Pa s]

p.eps_duct = 0.01;      % [m]
p.eps_heater = 2e-6;    % [m]
p.eps_enclosure = 1e-4; % [m]
p.eps_cabin = 5e-3;     % [m]

% this is a "fudge factor" for the flow resistance of the cabin.
% feel free to tune this so that the flow predicted for your system is correct
p.Cd = 1.08e6;          % [m]

%%
p.extra_mass = 3.48;    % mass of non-priced components ie foam, tube [kg]

%% covid transmission
p.vol_cabin_ft3 = 141;  % ft^3
p.L_cabin = 2;          % m
p.dp = 0.1;             % m
p.virions_per_min = 300;% virions/min
p.ft3tom3 = .3048^3;    % m^3/ft^3
p.Dh = 2;               % m
p.dist_ppl = 1;         % m
p.vol_lung = .5e-3;     % m^3
p.breath_min = 16;      % breaths/min
p.time = 30;            % min
p.vir_max = 1000;       % virions
p.mask_mult = 0.25;     % -