% Housekeeping
clc; clear; close all;

% Load dispersion dataset
dispersion_tag = 'control2';
load_file = ['./dispersion_datasets/' dispersion_tag '/dispersion_dataset_' dispersion_tag '.mat'];
load(load_file)

% Storage Location
complete_tag = 'control2';
save_file = ['./complete_datasets/complete_dataset_' complete_tag];
isSaveOutput = true;

% Bandgap analyis
[bandgaps,bandgap_edges] = calc_bandgaps(EIGENVALUE_DATA);
success_rate = sum(sum(bandgaps)>0)/length(bandgaps);

% Save output
if isSaveOutput == true
    vars_to_save = {'design_params','designs','const','ELASTIC_MODULUS_DATA', 'DENSITY_DATA', 'POISSON_DATA', 'WAVEVECTOR_DATA','EIGENVALUE_DATA','bandgaps','bandgap_edges'};
    save(save_file,vars_to_save{:});
end 

% Whether to continue with plotting
isPlotResults = true;
if isPlotResults == false
    return
end

% Bandgap width
fig = figure();
magic_plot_local(fig);
histogram(max(bandgaps))
xlim([0 800])
xlabel("Bandgap Width [Hz]")

% Bandgap location
fig = figure();
magic_plot_local(fig);
color = [0.5 0.5 0.5];
plot_bandgap_edges(bandgap_edges,color)
ylim([0 2000])
ylabel("Bandgap Location [Hz]")

% Pick design to plot
design_idx_to_plot = 1;

% Constitutive data
modulus = squeeze(ELASTIC_MODULUS_DATA(:,:,design_idx_to_plot));
density = squeeze(DENSITY_DATA(:,:,design_idx_to_plot));
poisson = squeeze(POISSON_DATA(:,:,design_idx_to_plot));
modulus = (modulus-my_min(modulus))/(my_max(modulus)-my_min(modulus));
density = (density-my_min(density))/(my_max(density)-my_min(density));
poisson = (poisson-my_min(poisson))/(my_max(poisson)-my_min(poisson));

% Plot design
fig = figure();
magic_plot_local(fig);
plot_design(cat(3,modulus, density, poisson),fig);

% Dispersion data
N_eig = size(EIGENVALUE_DATA,2);
wv = squeeze(WAVEVECTOR_DATA(:,:,design_idx_to_plot));
ev = squeeze(EIGENVALUE_DATA(:,:,design_idx_to_plot));

% Plot dispersion surface
fig = figure();
magic_plot_local(fig);
ax = axes(fig);
plot_dispersion_surface(wv,ev,const.N_wv(1),const.N_wv(2),ax);

function [bandgaps,bandgap_edges] = calc_bandgaps(eigs)
    N_struct = size(eigs,3);
    N_eig = size(eigs,2);
    bandgaps = zeros(N_eig-1,N_struct);
    bandgap_edges = zeros(2,N_eig-1,N_struct);
    for struct_idx = 1:N_struct
        for eig_pair_idx = 1:N_eig-1
            lower_band_max = max(eigs(:,eig_pair_idx,struct_idx));
            upper_band_min = min(eigs(:,eig_pair_idx+1,struct_idx));
            bandgaps(eig_pair_idx,struct_idx) = max(0,upper_band_min-lower_band_max);
            if bandgaps(eig_pair_idx,struct_idx) > 0
                bandgap_edges(1,eig_pair_idx,struct_idx) = lower_band_max;
                bandgap_edges(2,eig_pair_idx,struct_idx) = upper_band_min;
            end
        end
    end
end

function plot_bandgap_edges(bandgap_edges,color)
    N_struct = size(bandgap_edges,3);
    N_eig_pair = size(bandgap_edges,2);
    for struct_idx = 1:N_struct
        for eig_pair_idx = 1:N_eig_pair
            if bandgap_edges(1,eig_pair_idx,struct_idx) > 0
                y_lower = bandgap_edges(1,eig_pair_idx,struct_idx);
                y_upper = bandgap_edges(2,eig_pair_idx,struct_idx);
                fill([0,1,1,0], [y_lower, y_lower, y_upper, y_upper], color, 'FaceAlpha', 0.2, 'EdgeColor', 'none');
                hold on
            end
        end
    end
end