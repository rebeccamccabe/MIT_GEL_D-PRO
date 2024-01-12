clear
%% parameters
% open this file and adjust parameters to reflect your system and tune the 
% model to fit your measurements
p = parameters();

%% design variables and levels
% For now, this model assumes that if multiple parts are used, they are the same model.
% Feel free to change the design variables to encode different designs, for
% example if you want to examine using two different fans, first_fan = [1 2 3] and second_fan = [1 2 3]

which_fan = [1; 2; 3];
num_fans = [1; 2];
fans_series = [0; 1];

which_filter = [1; 2; 3];
num_filters = [1; 2];

which_heater = [0; 1; 2; 3];
num_heaters = [1; 2];

%% create every combination of design variables (full factorial)
levels = [length(which_fan), length(num_fans), length(fans_series), ...
            length(which_filter), length(num_filters), ...
            length(which_heater), length(num_heaters)  ];
idxs = fullfact(levels);

design = [which_fan(idxs(:,1)) num_fans(idxs(:,2)) fans_series(idxs(:,3)) ...
            which_filter(idxs(:,4)) num_filters(idxs(:,5)) ...
            which_heater(idxs(:,6)) num_heaters(idxs(:,7)) ];
        
%% simulate each combination
[flow,power,effic,time,mass,price] = simulation(design,p);
%% actual baseline
base_price = 525;
base_power = 109.2;
base_mass = 4.29;
base_vel = 0.5;
base_time = 600;
base_effic = .8;
base_flow = 12.2;
% have the above uncommented if you want to use measured values for baseline

%% predicted baseline
base_design = [2 3 0 2 1 3 1];
[base_flow,base_power,base_effic,base_time,base_mass,base_price] = simulation(base_design,p);
% have the above uncommented if you want to use simulated values for baseline

vel = 0; % this model assumes all designs can achieve perfect passenger airspeed

[sim_cost,sim_perf] = cost_perf_function(price, base_price, ...
                                 power, base_power, ...
                                 mass,  base_mass, ...
                                 effic, base_effic, ...
                                 flow,  base_flow, ...
                                 time,  base_time, ...
                                 vel,   base_vel, ...
                                 p);

%% plot pareto front
pareto()
plot(sim_cost,sim_perf,'*k','DisplayName','Simulations')
xlim([.6 1.8])
ylim([.7 1.7])

%% pareto front of simulations
all_cost = [sim_cost 1];
all_perf = [sim_perf 1];
[~,idxs] = paretoFront([-1*all_cost' all_perf']);
opt_cost = all_cost(idxs);
opt_perf = all_perf(idxs);
[opt_cost_sorted,sort_idxs] = sort(opt_cost);
opt_perf_sorted = opt_perf(sort_idxs);

plot(opt_cost_sorted,opt_perf_sorted,'k--','DisplayName','Simulated Pareto Front')

opt_designs = design(idxs,:)
