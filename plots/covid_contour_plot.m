clear
close all
%% constants
p = parameters();

%% variables
n = 20;
eff = linspace(0,1,n);
cfm = linspace(0,20,n);
[EFF,CFM] = meshgrid(eff,cfm);

%% calculations
P_infect = covid_transmission(EFF,CFM,p)

figure
[C,h] = contourf(EFF,CFM,P_infect*100,[0 3:10 12 15 20 30 30:20:90 101]);
grid on
clabel(C,h)
set(gca,'ColorScale','log')
xlabel('Total Filter Efficiency')
ylabel('CFM')
title('Probability of Infection (%)')
improvePlot
