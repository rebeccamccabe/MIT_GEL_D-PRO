speed = linspace(1,10,30);
pressure = 1./speed;

fan.speed = speed;
fan.pressure = pressure;

series.speed = speed;
series.pressure = 2*pressure;

parallel.speed = 2*speed;
parallel.pressure = pressure;

figure
plot(speed,.01*speed.^2,'DisplayName','System')
hold on
plot(fan.speed,fan.pressure,'DisplayName','Single Fan')
plot(series.speed,series.pressure,'DisplayName','2 Series')
plot(parallel.speed,parallel.pressure,'DisplayName','2 Parallel')
legend

rho = 1.22;
coeff = 1/2*rho*3/(60*.14)^4;