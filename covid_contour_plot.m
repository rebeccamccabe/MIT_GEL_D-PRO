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
contourf(EFF,CFM,P_infect*100)
colorbar
xlabel('Total Filter Efficiency')
ylabel('CFM')
title('Probability of Infection (%)')
