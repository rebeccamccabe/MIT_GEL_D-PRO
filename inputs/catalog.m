function [mass,price] = catalog(which_fan,num_fans,which_filter,num_filters,which_heater,num_heaters,p)

% fans
if which_fan == 1
    fan_mass = .4;
    fan_price = 100;
elseif which_fan == 2
    fan_mass = .19;
    fan_price = 140;
elseif which_fan == 3
    fan_mass = .19;
    fan_price = 200;
end
fan_mass = fan_mass * num_fans;
fan_price = fan_price * num_fans;

% filters
if which_filter == 1
    filter_mass = .276;
    filter_price = 20;
elseif which_filter == 2
    filter_mass = .109;
    filter_price = 45;
elseif which_filter == 3
    filter_mass = .117;
    filter_price = 100;
end
filter_mass = filter_mass * num_filters;
filter_price = filter_price * num_filters;

% heaters
if which_heater == 0
    heater_mass = 0.038;
    heater_price = 15;
elseif which_heater == 1
    heater_mass = .074;
    heater_price = 30;
elseif which_heater == 2
    heater_mass = .128;
    heater_price = 45;
elseif which_heater == 3
    heater_mass = .132;
    heater_price = 60;
end
heater_mass = heater_mass * num_heaters;
heater_price = heater_price * num_heaters;

% total
mass = fan_mass + filter_mass + heater_mass + p.extra_mass;
price = fan_price + filter_price + heater_price;

end