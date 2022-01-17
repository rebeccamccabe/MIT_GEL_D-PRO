kmh_to_mps = 0.2777;

file = 'C:\Users\chess\OneDrive\Documents\MIT\MIT Classes\16.810\WLTP-Driving-Cycle.xls';
% from https://unece.org/DAM/trans/doc/2012/wp29grpe/WLTP-DHC-12-07e.xls
data = readmatrix(file,'Sheet','WLTC_class_3','Range','C:F');

time = data(:,1);
vel = data(:,3) * kmh_to_mps;
accel = data(:,4);

close all
figure
plot(time,vel,time,accel)

watts_per_kg = vel .* accel;

idx_braking = accel<0;
watts_per_kg_accel = watts_per_kg;
watts_per_kg_accel(idx_braking) = 0;

figure
plot(time,watts_per_kg_accel)
hold on
avg = mean(watts_per_kg_accel(watts_per_kg_accel>0));
plot([min(time) max(time)],[1 1]*avg)

m = 2000;
P_kw = watts_per_kg_accel * m / 1000;
figure
plot(time,P_kw)
title('Power for 2000 kg car')

eff_regen = 0.8;
eff_drive = 0.9;
eff_tot = 1-(1/eff_drive - eff_regen);
W_per_kg = (1-eff_tot) * avg;
