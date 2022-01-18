
function [flow,power,eff,time,mass,price] = simulation(design,p)

[flow,power,eff,time,mass,price] = deal(zeros(1,size(design,1)));
for i = 1:size(design,1)
    which_fan = design(i,1);
    num_fans = design(i,2);
    fans_series = design(i,3);
    which_filter = design(i,4);
    num_filters = design(i,5);
    which_heater = design(i,6);
    num_heaters = design(i,7);

    [fanP,fanQ] = fan_curve(which_fan,num_fans,fans_series);
    [eff(i),k_filter] = filters(which_filter,num_filters);
    [N_cells,m_heater] = heaters(which_heater,num_heaters);
    
    [flow(i),fan_power] = pipe_flow(fanP,fanQ,k_filter,N_cells,p);
    [time(i),heater_power] = thermals_ode(flow(i), N_cells, m_heater, p);

    [mass(i),price(i)] = catalog(which_fan,num_fans,which_filter,num_filters,which_heater,num_heaters,p);
    power(i) = fan_power + heater_power;
end
end