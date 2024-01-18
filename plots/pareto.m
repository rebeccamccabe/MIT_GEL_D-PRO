function [] = pareto()
close all;clc

%% Load spreadsheet data
folder = 'C:\Users\rgm222\OneDrive\Documents\MIT\MIT Classes\16.810\';
files = {[folder 'V1 Results Team 1.xlsx'], [folder 'V1 Results Team 2.xlsx'], ...
    [folder 'V1 Results Team 3.xlsx'], [folder 'V1 Results Team 4.xlsx'], ...
    [folder 'V2 Results Team 1.xlsx'], [folder 'V2 Results Team 2.xlsx'], ...
    [folder 'V2 Results Team 3.xlsx'], [folder 'V2 Results Team 4.xlsx'], ...
    [folder 'V3 Results Team 2.xlsx'], [folder 'V4 Results Team 2.xlsx'], ...
    [folder 'V1 Results GMW Baseline.xlsx']};


cost_cell = 10;
mass_cell = 16;
eff_cells = 17:19;
pwr_cell  = 30;
flow_cell = 32;
time_cell = 35;
vel_cells = 36:37;

start_cell = 5; % number of empty cells at beginning of col D in spreadsheet

for team=1:length(files)
    if exist(files{team},'file')
        mat = readmatrix(files{team},'Range','D:D');

        c = mat(cost_cell-start_cell);
        p = mat(pwr_cell-start_cell);
        m = mat(mass_cell-start_cell);
        t = mat(time_cell-start_cell);
        f = mat(flow_cell-start_cell);

        one_minus_effs = 1-mat(eff_cells-start_cell)/100;
        e = 1 - prod(one_minus_effs,'omitnan');

        vels = mat(vel_cells-start_cell);
        v = sum(abs(vels-0.4));
    else
        warning(['Cannot find results file for team ',num2str(team),'. Setting to zero.'])
        [c,p,m,t,f,e,v] = deal(0); % when team results sheets aren't available, set = 0.
    end
    
    if team<length(files) % teams  
        [price(team),power(team),mass(team),time(team),flow(team),effic(team),vel(team)] ...
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
% axes to show dominated
plot([1 1],[0 2],'k:','LineWidth',0.5,'HandleVisibility','off')
hold on
plot([0 2],[1 1],'k:','LineWidth',0.5,'HandleVisibility','off')
% pareto front
plot(opt_cost_sorted,opt_perf_sorted,'k--','DisplayName','Measured Pareto Front')
% team tests
scatter(cost(1:4),perf(1:4),200,'c^','Filled','MarkerEdgeColor','b','LineWidth',1,'DisplayName','Team Tests V1')
scatter(cost(5:8),perf(5:8),200,'m^','Filled','MarkerEdgeColor','b','LineWidth',1,'DisplayName','Team Tests V2')
scatter(cost(9:10),perf(9:10),200,'y^','Filled','MarkerEdgeColor','b','LineWidth',1,'DisplayName','Team Tests V3/4')
% labels
text(cost-.01,perf,{'1','2','3','4','1','2','3','4','2','2'})
% dashes showing improvement
for team=1:4
    idxs = [0,4]+team;
    if team==2
        idxs = [idxs 9 10];
    end
	plot(cost(idxs),perf(idxs),'k:','LineWidth',0.5,'HandleVisibility','off')
end

plot(1,1,'rx','DisplayName','GMW Baseline')
plot(min([cost 1]),max([perf 1]),'gp','DisplayName','Utopia Point')
xlim([0.5 1.8])
ylim([0.5 1.8])
xlabel('Cost')
ylabel('Performance')
title('Final Results')
improvePlot
legend('Location','southeast')
end