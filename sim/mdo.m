%% design variables and levels
% for now, assume that if multiple parts are used, they are the same model

which_fan = [1 2 3];
num_fans = [1 2];
fans_series = [0 1];

which_filter = [1 2 3];
num_filters = [1 2];

which_heater = [1,2,3,4];
num_heaters = [1,2];

diameter_pipe_inches = [3 4];

%% create every combination of design variables (full factorial)
levels = [length(which_fan), length(num_fans), length(fans_series), ...
            length(which_filter), length(num_filters), ...
            length(which_heater), length(num_heaters), ...
            length(diameter_pipe_inches) ];
idxs = fullfact(levels);

design = [which_fan(idxs(:,1)) num_fans(idxs(:,2)) fans_series(idxs(:,3)) ...
            which_filter(idxs(:,4)) num_filters(idxs(:,5)) ...
            which_heater(idxs(:,6)) num_heater(idxs(:,7)) ...
            diameter_pipe_inches(idxs(:,8)) ];
        
%% simulate each combination
flow = pipe_flow(design,p);
eff = filter_efficiency(design,p);
prob = covid_transmission(eff,flow,p);
temp = thermals(design,p);

cost = cost_function(mass,price,energy);
perf = perf_function(prob,temp);

%% plot pareto front
figure
plot(cost,perf,'*')
