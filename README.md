# For everyone running any file:
- Highlight the folder all the files in this repository. Right click and select Add to Path. 
- If you get the error `'<your_function>' is not found in the current folder or on the MATLAB path`, you haven't done this step correctly

# For students performing thermal analysis:
- Input your V_air, mdot_frac, and A_frac into `parameters.m`
- Call `thermals_ode(CFM, N_cells, m_heater, parameters())` with your CFM, N_cells, and m_heater

# For students simulating their full system:
- Input all your parameters into `parameters.m`
- Create a design vector representing your system: `design = [which_fan, num_fans,
        fans_series, which_filter, num_filters, which_heater, num_heaters]` according to the chart below
- Run `[flow,power,eff,time,mass,price] = simulation(design, parameters())`

| Design variable    | 0 | 1 | 2 | 3 |
| ----------- | --- | --- | --- | --- |
| which_fan   | - | A20 800 rpm | A14 2000 rpm | A14 3000 rpm |
| num_fans    | - | 1 fan | 2 fans | - |
| fan_series  |  no - parallel  | yes - series| - | - |
| which_filter | - | A - 3M | B - Bosch | C - Bosch HEPA |
| num_filters | - | 1 filter | 2 filters | - |
| which_heater | A - 50W | B - 100W | C - 150W | D - 200W |
| num_heaters| - | 1 heater | 2 heaters | - | 

# For students performing optimization:
- Input all your parameters into `parameters.m`
- Run `mdo()`. Expect this to take around 5 minutes to run.

# For instructors generating the team results comparison figure:
- Modify lines 5-11 of `plots/pareto.m` according to the filenames and path of the results spreadsheets
- Modify lines 96-107 according to which versions you want to plot (1, 2, 3/4).
- Run `pareto()`
