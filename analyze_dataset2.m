clc; clear; close all;
colors = magic_plot();

%%% data to load
% output_folder = 'MYOUTPUT/output 13-Nov-2024 11-22-54/'; % 16 pix, 8 fold symmetry, 8 pix correlation
% output_folder = 'MYOUTPUT/output 13-Nov-2024 11-32-24/'; % 16 pix, 4 fold symmetry, 8 pix correlation 
% output_folder = 'MYOUTPUT/output 13-Nov-2024 13-17-14/'; % 16 pix, no symmetry, 16 pix correlation
output_folder = 'MYOUTPUT/output 13-Nov-2024 11-27-52/'; % 16 pix, no symmetry, 8 pix correlation
% output_folder = 'MYOUTPUT/output 13-Nov-2024 11-36-47/'; % 16 pix, no symmetry, 4 pix correlation
% output_folder = 'MYOUTPUT/output 13-Nov-2024 13-11-18/'; % 16 pix, no symmetry, 2 pix correlation
% output_folder = 'MYOUTPUT/output 13-Nov-2024 12-26-18/'; % 16 pix, no symmetry, 8 pix correlation, [-1 1] threshold
% output_folder = 'MYOUTPUT/output 13-Nov-2024 12-30-14/'; % 16 pix, no symmetry, 8 pix correlation, [-0.5 0.5] threshold
% output_folder = 'MYOUTPUT/output 13-Nov-2024 14-44-21/'; % 16 pix, 8 fold symmetry, 8 pix correlation, [-0.5 0.5] threshold
mat_files = dir(fullfile(output_folder, '*.mat'));

for i = 1:length(mat_files)
    load(fullfile(output_folder, mat_files(i).name));
end

struct_idx_to_plot = 19;

[bandgaps,bandgap_edges] = calc_bandgaps(EIGENVALUE_DATA);
success_rate = sum(sum(bandgaps)>0)/length(bandgaps);

figure();
histogram(max(bandgaps))
xlim([0 5000])
xlabel("Bandgap Width")

figure();
plot_bandgap_edges(bandgap_edges,[0.5 0.5 0.5])
ylim([0 12000])
ylabel("Bandgap Location")

ELASTIC_MODULUS_DATA = CONSTITUTIVE_DATA('modulus');
DENSITY_DATA = CONSTITUTIVE_DATA('density');
POISSON_DATA = CONSTITUTIVE_DATA('poisson');
N_eig = size(EIGENVALUE_DATA,2);

ELASTIC_MODULUS_DATAi = squeeze(ELASTIC_MODULUS_DATA(:,:,struct_idx_to_plot));
DENSITY_DATAi = squeeze(DENSITY_DATA(:,:,struct_idx_to_plot));
POISSON_DATAi = squeeze(POISSON_DATA(:,:,struct_idx_to_plot));

WAVEVECTOR_DATAi = squeeze(WAVEVECTOR_DATA(:,:,struct_idx_to_plot));
EIGENVALUE_DATAi = squeeze(EIGENVALUE_DATA(:,:,struct_idx_to_plot));

ELASTIC_MODULUS_DATAi = (ELASTIC_MODULUS_DATAi-my_min(ELASTIC_MODULUS_DATAi))/(my_max(ELASTIC_MODULUS_DATAi)-my_min(ELASTIC_MODULUS_DATAi));
DENSITY_DATAi = (DENSITY_DATAi-my_min(DENSITY_DATAi))/(my_max(DENSITY_DATAi)-my_min(DENSITY_DATAi));
POISSON_DATAi = (POISSON_DATAi-my_min(POISSON_DATAi))/(my_max(POISSON_DATAi)-my_min(POISSON_DATAi));

plot_design(cat(3,ELASTIC_MODULUS_DATAi, DENSITY_DATAi, POISSON_DATAi))

N_k_y = 1;
N_wv = length(WAVEVECTOR_DATAi);
while WAVEVECTOR_DATAi(N_k_y+1,1) == WAVEVECTOR_DATAi(N_k_y,1)
    N_k_y = N_k_y + 1;
    if N_k_y == N_wv
        error("Could not figure out dimensions of wavevector grid.")
    end
end
if mod(N_wv,N_k_y) == 0
    N_k_x = length(WAVEVECTOR_DATAi)/N_k_y;
else
    error("Could not figure out dimensions of wavevector grid.")
end

fig = figure();
ax = axes(fig);
hold on
for eig_idx = 1:N_eig
    wv_plot = WAVEVECTOR_DATAi;
    fr_plot = EIGENVALUE_DATAi(:,eig_idx);
    plot_dispersion_surface(wv_plot,fr_plot,N_k_x,N_k_y,ax);
    grid on
end
view([-1,-1,0.5])

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
                % Define the x and y ranges
                y_lower = bandgap_edges(1,eig_pair_idx,struct_idx);
                y_upper = bandgap_edges(2,eig_pair_idx,struct_idx);
                
                % Define color and transparency
                transparency = 0.2;
                
                % Plot the shaded horizontal area
                fill([0,1,1,0], [y_lower, y_lower, y_upper, y_upper], color, 'FaceAlpha', transparency, 'EdgeColor', 'none');
                hold on
            end
        end
    end
end