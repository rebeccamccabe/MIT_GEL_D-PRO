% Filtrete 3M mpp300

flow = [290 430 575 720 970]; % CFM; 
pressure = [.1  .17 .24 .34 .51]*249.09; % inches water column converted to Pa

f = [0 13.5 flow];
p = [0 2.5 pressure];

figure
plot(f,p)
title('3M Filtrete mpp300')

k = 15e-5;
p_fit = k*f.^2;

hold on
plot(f,p_fit)
legend('actual','fit')