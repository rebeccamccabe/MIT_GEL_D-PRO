function [N_cells,m_heater] = heaters(which_heater,num_heaters)
if which_heater == 0
    N_cells = 80;
    m_heater = .013;
elseif which_heater == 1
    N_cells = 120;
    m_heater = .02;
elseif which_heater == 2
    N_cells = 120;
    m_heater = 0.034;
elseif which_heater == 3
    N_cells = 240;
    m_heater = 0.06;
end
N_cells = N_cells * num_heaters;
m_heater = m_heater * num_heaters;

end