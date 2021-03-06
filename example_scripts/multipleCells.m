% LIONSIMBA example script
% Multiple cells scenario: simulates three cells in serial connection.

%   This file is part of the LIONSIMBA Toolbox
%
%	Official web-site: 	http://sisdin.unipv.it/labsisdin/lionsimba.php
% 	Official GitHUB: 	https://github.com/lionsimbatoolbox/LIONSIMBA
%
%   LIONSIMBA: A Matlab framework based on a finite volume model suitable for Li-ion battery design, simulation, and control
%   Copyright (C) 2016-2018 :Marcello Torchio, Lalo Magni, Davide Raimondo,
%                            University of Pavia, 27100, Pavia, Italy
%                            Bhushan Gopaluni, Univ. of British Columbia, 
%                            Vancouver, BC V6T 1Z3, Canada
%                            Richard D. Braatz, 
%                            Massachusetts Institute of Technology, 
%                            Cambridge, Massachusetts 02142, USA
%   
%   Main code contributors to LIONSIMBA 2.0:
%                           Ian Campbell, Krishnakumar Gopalakrishnan,
%                           Imperial college London, London, UK
%
%   LIONSIMBA is a free Matlab-based software distributed with an MIT
%   license.

% Clear the workspace
clear

% Define the integration times.
t0 = 0;
tf = 10^4;
% Define the parameters structure.
param{1} = Parameters_init;
param{2} = Parameters_init;
param{3} = Parameters_init;

% Modify the initial SOC of cell #1
param{1}.cs_n_init = 0.95*param{1}.cs_n_init;

% Double the length of the positive electrode of cell #2
param{2}.len_p=2*param{2}.len_p;

% Simulate the battery of 3 cells
results = startSimulation(t0,tf,[],-30,param);

ncells = length(param);

v_tot = 0;
for i=1:ncells
    v_tot = v_tot + results.Phis{i}(:,1)-results.Phis{i}(:,end);
end
%% Plot the results

figure(1)
subplot(2,ncells,(1:ncells))
plot(results.time{1},v_tot,'LineWidth',6)
grid on
box on
xlabel('Time [s]')
ylabel('Pack Voltage [V]')
hold on
xlim([0 results.time{1}(end)])
ylim([2.5*length(param) 4.2*length(param)])

figure_index = ncells+1;
for i=1:ncells
    subplot(2,ncells,figure_index)
    plot(results.time{i},results.Voltage{i},'--','LineWidth',3)
    grid on
    box on
    xlabel('Time [s]')
    ylabel(['Cell #',num2str(i),' Voltage [V]'])
    figure_index = figure_index+1;
    ylim([2.5 4.2])
    xlim([0 results.time{1}(end)])
end

n_plots = 1;
figure_index = 1;
figure(2)
for i=1:ncells
    subplot(ncells,n_plots,figure_index)
    ce_indices = [1 results.parameters{i}.Np+1 results.parameters{i}.Np+results.parameters{i}.Ns results.parameters{i}.Np+results.parameters{i}.Ns+results.parameters{i}.Nn];
    plot(results.time{i},results.ce{i}(:,ce_indices),'LineWidth',3)
    grid on
    box on
    if(figure_index==ncells)
        xlabel('Time [s]')
    else
%         set(gca,'xtick',[])
        set(gca,'xticklabel',[])
    end
    ylabel(['Cell #',num2str(i),' - c_{e} [mol/m^3}'])
    xlim([0 results.time{1}(end)])
    ylim([0 2200])
    figure_index = figure_index+1;
end


n_plots = 1;
figure_index = 1;
figure(3)
for i=1:ncells
    subplot(ncells,n_plots,figure_index)
    phie_indices = [1 results.parameters{i}.Np+1 results.parameters{i}.Np+results.parameters{i}.Ns results.parameters{i}.Np+results.parameters{i}.Ns+results.parameters{i}.Nn];
    plot(results.time{i},results.Phie{i}(:,phie_indices),'LineWidth',3)
    grid on
    box on
    if(figure_index==ncells)
        xlabel('Time [s]')
    else
%         set(gca,'xtick',[])
        set(gca,'xticklabel',[])
    end
    ylabel(['Cell #',num2str(i)])
    xlim([0 results.time{1}(end)])
    ylim([-0.3 0])
    figure_index = figure_index+1;
end


n_plots = 1;
figure_index = 1;
figure(4)
for i=1:ncells
    subplot(ncells,n_plots,figure_index)
    cs_indices = [1 results.parameters{i}.Np results.parameters{i}.Np+1 results.parameters{i}.Np+results.parameters{i}.Nn];
    plot(results.time{i},results.cs_surface{i}(:,cs_indices),'LineWidth',3)
    grid on
    box on
    if(figure_index==ncells)
        xlabel('Time [s]')
    else
%         set(gca,'xtick',[])
        set(gca,'xticklabel',[])
    end
    ylabel(['Cell #',num2str(i)])
    xlim([0 results.time{1}(end)])
    ylim([100 51554])
    figure_index = figure_index+1;
end


n_plots = 1;
figure_index = 1;
figure(5)
for i=1:ncells
    subplot(ncells,n_plots,figure_index)
    cs_indices = [1 results.parameters{i}.Np results.parameters{i}.Np+1 results.parameters{i}.Np+results.parameters{i}.Nn];
    plot(results.time{i},results.Temperature{i}(:,end),'LineWidth',3)
    grid on
    box on
    if(figure_index==ncells)
        xlabel('Time [s]')
    else
%         set(gca,'xtick',[])
        set(gca,'xticklabel',[])
    end
    ylabel(['Cell #',num2str(i),' - Temp [K]'])
    xlim([0 results.time{1}(end)])
    ylim([296 315])
    figure_index = figure_index+1;
end
