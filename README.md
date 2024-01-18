[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=rebeccamccabe/MIT_GEL_D-PRO)

# Overview
These numerical modeling tools were developed by @rebeccamccabe in 2022 for the MIT IAP Class 16.810: Engineering Design and Rapid Prototyping.
They include scripts to simulate the airflow, transient heat transfer, and virus transmission of a vehicle cabin, 
as well as scripts to perform multidisciplinary design optimization on the system and visualize the pareto front.
For information on the class, see the [subject listing](https://student.mit.edu/catalog/search.cgi?search=16.810) 
and this [MIT News Article](https://news.mit.edu/2022/mit-engineering-design-rapid-prototyping-course-gets-refresh-0304).

# Instructions
## For everyone running any file:
- Highlight the folder all the files in this repository. Right click and select Add to Path. 
- If you get the error `'<your_function>' is not found in the current folder or on the MATLAB path`, you haven't done this step correctly

## For students performing thermal analysis:
- Input your V_air, mdot_frac, and A_frac into `parameters.m`
- Run `[N_cells,m_heater] = heaters(which_heater,num_heaters)`
- Run `thermals_ode(CFM, N_cells, m_heater, parameters())` with your CFM

## For students simulating their full system:
- Input all your parameters into `parameters.m`
- Create a design vector representing your system: `design = [which_fan, num_fans,
        fans_series, which_filter, num_filters, which_heater, num_heaters]` according to the chart below
- Run `[flow,power,eff,time,mass,price] = simulation(design, parameters())`

| Design variable    | 0 | 1 | 2 | 3 |
| -----------  | --- | --- | --- | --- |
| which_fan    | - | A20 800 rpm | A14 2000 rpm | A14 3000 rpm |
| num_fans     | - | 1 fan | 2 fans | - |
| fan_series   |  no - parallel  | yes - series| - | - |
| which_filter | - | A - 3M | B - Bosch | C - Bosch HEPA |
| num_filters  | - | 1 filter | 2 filters | - |
| which_heater | A - 50W | B - 100W | C - 150W | D - 200W |
| num_heaters  | - | 1 heater | 2 heaters | - | 

## For students performing optimization:
- Input all your parameters into `parameters.m`
- Run `mdo()`. Expect this to take around 5 minutes to run.

## For instructors generating the team results comparison figure:
- Modify lines 5-11 of `plots/pareto.m` according to the filenames and path of the results spreadsheets
- Modify lines 96-107 according to which versions you want to plot (1, 2, 3/4).
- Run `pareto()`
