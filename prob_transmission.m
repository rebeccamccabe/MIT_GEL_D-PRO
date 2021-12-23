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
ACH = CFM*60/p.vol_cabin_ft3;
diff = 0.005 * ACH.^0.06;
expo = 1e-12./diff;

vol_diff_rate = 0.3 * diff * pi * p.L_cabin * 60 / p.dp;
virion_conc = p.virions_per_min ./ vol_diff_rate;
C_out = p.virions_per_min ./ (CFM * p.ft3tom3 .* EFF);
C_s = virion_conc + C_out;

A = virion_conc ./ ( (p.dp/2).^expo + (p.Dh/2).^expo );
B = C_s - A .* (p.dp/2).^expo;
C_x = A .* p.dist_ppl.^expo + B;

vir_breath = C_x * p.vol_lung;
vir_total = p.mask_mult * vir_breath * p.breath_min * p.time;

P_infect = 1-exp(-vir_total/p.vir_max)

figure
contourf(EFF,CFM,P_infect*100)
colorbar
xlabel('Total Filter Efficiency')
ylabel('CFM')
title('Probability of Infection (%)')
