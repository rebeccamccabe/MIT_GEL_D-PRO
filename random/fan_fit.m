close all
% A14 2000 rpm
% m3/hr converted to CFM
flow = [182.5 138.1 93.5 42.7 0]*.5886;
% mm water converter to Pa
pressure = [0.0 1.21 1.74 3.17 4.18]*9.807;

%% one fan system
figure
plot(flow,pressure,'DisplayName','Fan')
hold on
pres = [0 45];
plot([3.6 3.6],pres,'DisplayName','Standard')
plot([2.6 2.6],pres,'DisplayName','HEPA')

plot(flow,610*.001*flow.^2,'DisplayName','k=0.61')
plot(flow,440*.001*flow.^2,'DisplayName','k=0.44')
ylim([0 50])
xlim([0 5])
grid on

legend
xlabel('flow CFM')
ylabel('pressure Pa')
title('One Fan System')
%% three fan system, with poorly mounted heater
figure
plot(3*flow,pressure,'DisplayName','Fans')
hold on
plot([13.5 13.5],pres,'r--','DisplayName','No filter')
plot([12.7 12.7],pres,'g--','DisplayName','Filtrete')
plot([12.4 12.4],pres,'b--','DisplayName','Standard')
plot([10.7 10.7],pres,'k--','DisplayName','HEPA')

plot(flow,147*.001*flow.^2,'k','DisplayName','k=0.147')
plot(flow,126*.001*flow.^2,'b','DisplayName','k=0.126')
plot(flow,123*.001*flow.^2,'g','DisplayName','k=0.123')
plot(flow,116*.001*flow.^2,'r','DisplayName','k=0.116')

ks = [147 126 123] - 116

legend
xlabel('flow CFM')
ylabel('pressure Pa')
title('Three Fan System')
ylim([25 50])
xlim([10 15])
grid on

%% 3 fan system, with wood-mounted heater
close all

no_filter_data = [5.1 8.9 14.4];
filtrete_data = [4.5 8.0 13.9];
std_filter_data = [4.3 7.7 13.2];
hepa_filter_data = [3.1 6.2 6.5];

data = [no_filter_data; filtrete_data; std_filter_data; hepa_filter_data];
filters = {'No Filter ','Filtrete ','Standard ','HEPA '};
cols = {'r','g','b','k'};

figure(1)
plot(flow,pressure,'DisplayName','1 Fan')
hold on
plot(2*flow,pressure,'DisplayName','2 Fans')
plot(3*flow,pressure,'DisplayName','3 Fans')


pres = [0 45];
deltaP = zeros(4,3);
coeff = [0 0 0 0];
start = [0 3 5 21];
for i=1:4 % for each filter
    fdata = data(i,:);
    pdata = [0 0 0];
    for j = 1:3 % for each fan setting
        pdata(j) = interp1(j*flow,pressure,fdata(j)); 
    end
    figure(1)
    plot(fdata,pdata,[cols{i} '*-'],'DisplayName',filters{i})
    if i==1
        P_baseline = pdata;
    else % for all except no filter
        deltaP(i,:) = pdata - P_baseline;
        figure(2)
        hold on
        fo = fit(fdata',deltaP(i,:)',fittype('a*x^2*1e-3'),'StartPoint',start(i));
        coeff(i) = fo.a;
        h = plot(fo,cols{i},fdata',deltaP(i,:)',[cols{i} '*-']);
        h(1).DisplayName = [filters{i} ' fit'];
        h(2).DisplayName = [filters{i} ' data'];
    end
    
end

figure(1)
%plot(flow,610*.001*flow.^2,'DisplayName','k=0.61')
%plot(flow,440*.001*flow.^2,'DisplayName','k=0.44')
figure(1)
ylim([38 41])
xlim([0 15])
grid on

legend
xlabel('flow CFM')
ylabel('pressure Pa')
title('Filter Flow Test')

figure(2)
xlabel('flow CFM')
ylabel('pressure drop Pa')
title('Filter PQ Characteristics')
legend