function p = parameters()

%% pipe flow
p.L_duct = 2;           % m
p.L_heater = 0.02;      % m
p.L_enclosure = 0.5;    % m
p.L_cabin = 1;          % m

p.D_duct = 0.1;         % m
p.D_heater = 0.005;     % m
p.D_enclosure = 0.1;    % m
p.D_cabin = 1;          % m

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