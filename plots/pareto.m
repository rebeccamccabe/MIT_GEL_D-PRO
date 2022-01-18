function [] = pareto()
close all;clc

%% Load spreadsheet data
file = 'C:\Users\chess\OneDrive\Documents\MIT\MIT Classes\16.810\V1 Results';
files = {[file ' Team 1.xlsx'], [file ' Team 2.xlsx'], ...
    [file ' Team 3.xlsx'], [file ' Team 4.xlsx'], [file ' GMW Baseline.xlsx']};

cost_cell = 10;
mass_cell = 16;
eff_cells = 17:19;
pwr_cell  = 30;
flow_cell = 32;
time_cell = 35;
vel_cells = 36:37;

start_cell = 6;

for i=1:length(files)
    mat = readmatrix(files{i},'Range','D:D');
    
    c = mat(cost_cell-start_cell);
    p = mat(pwr_cell-start_cell);
    m = mat(mass_cell-start_cell);
    t = mat(time_cell-start_cell);
    f = mat(flow_cell-start_cell);
    
    one_minus_effs = 1-mat(eff_cells-start_cell)/100;
    e = 1 - prod(one_minus_effs,'omitnan');
    
    vels = mat(vel_cells-start_cell);
    v = sum(abs(vels-0.4));
    
    if i<length(files) % teams  
        [price(i),power(i),mass(i),time(i),flow(i),effic(i),vel(i)] ...
            = deal(c,p,m,t,f,e,v);
    else % baseline
        base_price = c;
        base_power = p;
        base_mass = m;
        base_effic = e;
        base_flow = f;
        base_time = t;
        base_vel = v;
    end
end

%% dummy data to test graph if spreadsheets aren't available
% monetary_cost = [1 1.5 1 1.5];
% power = [60 50 60 70];
% mass = [4 3 2 1];
% time = [1 2 1 2];
% flow = [15 10 10 15];
% effic = [.8 .7 .8 .9];
% vel = [.5 .5 .5 .5];

%% evaluate cost and performance
[cost,perf] = cost_perf_function(price, base_price, ...
                                 power, base_power, ...
                                 mass,  base_mass, ...
                                 effic, base_effic, ...
                                 flow,  base_flow, ...
                                 time,  base_time, ...
                                 vel,   base_vel, ...
                                 parameters() );

%% find pareto optimal points
all_cost = [cost 1];
all_perf = [perf 1];
[~,idxs] = paretoFront([-1*all_cost' all_perf']);
opt_cost = all_cost(idxs);
opt_perf = all_perf(idxs);
[opt_cost_sorted,sort_idxs] = sort(opt_cost);
opt_perf_sorted = opt_perf(sort_idxs);

%% make pareto front graph
figure
plot([1 1],[0 2],'k:','LineWidth',0.5,'HandleVisibility','off')
hold on
plot([0 2],[1 1],'k:','LineWidth',0.5,'HandleVisibility','off')
plot(opt_cost_sorted,opt_perf_sorted,'k--','DisplayName','Measured Pareto Front')
scatter(cost,perf,100,'c^','Filled','MarkerEdgeColor','b','LineWidth',1,'DisplayName','Team Tests')
plot(1,1,'rx','DisplayName','GMW Baseline')
plot(min([cost 1]),max([perf 1]),'gp','DisplayName','Utopia Point')
xlim([0.9 1.8])
ylim([0.9 1.6])
xlabel('Cost')
ylabel('Performance')
title('Version 1 Results')
improvePlot
legend
end