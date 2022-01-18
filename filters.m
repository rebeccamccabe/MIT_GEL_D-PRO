function [eff,k_filter] = filters(which_filter,num_filters)

if which_filter == 1
    eff = .55;
    k_filter = 1.5e-3;
elseif which_filter == 2
    eff = 0.8;
    k_filter = 2e-3;
elseif which_filter == 3
    eff = .9997;
    k_filter = 21e-3;
end

eff = 1 - (1-eff)^num_filters;
k_filter = k_filter * num_filters;

end