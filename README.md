# For everyone running any file:
- Highlight the folder all the files in this repository. Right click and select Add to Path. 
- If you get the error `'<your_function>' is not found in the current folder or on the MATLAB path`, you haven't done this step correctly

# For students performing thermal analysis:
- Input your V_air, mdot_frac, and A_frac into `parameters.m`
- Call `thermals_ode(CFM, N_cells, m_heater, parameters())` with your CFM, N_cells, and m_heater

# For students simulating their full system:
- Input all your parameters into `parameters.m`
- Create a design vector representing your system: `design = [which_fan, num_fans,
        fans_series, which_filter, num_filters, which_heater, num_heaters]`
- Run `[flow,power,eff,time,mass,price] = simulation(design, parameters())`

# For students performing optimization:
- Input all your parameters into `parameters.m`
- Run `mdo()`

# For instructors generating the team results comparison figure:
- Modify lines 5-11 of `plots/pareto.m` according to the filenames and path of the results spreadsheets
- Modify lines 96-107 according to which versions you want to plot (1, 2, 3/4).
- Run `pareto()`