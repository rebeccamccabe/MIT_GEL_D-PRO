function p = parameters()

%% pipe loss
p.L_pipe = 2;           % m
p.K_turn = 0.5;         % - 
p.K_enter = 0.5;        % -
p.K_exit = 1;           % -



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