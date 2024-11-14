clc; clear; close all;

%%% data to load
output_folder = 'MYOUTPUT/output 07-Nov-2024 13-51-11/';
mat_files = dir(fullfile(output_folder, '*.mat')); 

for i = 1:length(mat_files)
    load(fullfile(output_folder, mat_files(i).name)); 
end

struct_idx_to_plot = 1;

ELASTIC_MODULUS_DATA = CONSTITUTIVE_DATA('modulus');
DENSITY_DATA = CONSTITUTIVE_DATA('density');
POISSON_DATA = CONSTITUTIVE_DATA('poisson');
N_eig = size(EIGENVALUE_DATA,2);

fig = figure();
ax = axes(fig);
plot_design(cat(3,squeeze(ELASTIC_MODULUS_DATA(:,:,struct_idx_to_plot)), squeeze(DENSITY_DATA(:,:,struct_idx_to_plot)), squeeze(POISSON_DATA(:,:,struct_idx_to_plot))))

fig = figure();
ax = axes(fig);
hold on
for eig_idx_to_plot = 1:const.N_eig
    wv_plot = squeeze(WAVEVECTOR_DATA(:,:,struct_idx_to_plot));
    fr_plot = squeeze(EIGENVALUE_DATA(:,eig_idx_to_plot,struct_idx_to_plot));
    plot_dispersion_surface(wv_plot,fr_plot,[],[],ax);
end
view(3)

% fig = figure();
% ax = axes(fig);
% plot_design(cat(3,squeeze(ELASTIC_MODULUS_DATA(:,:,struct_idx_to_plot)), squeeze(DENSITY_DATA(:,:,struct_idx_to_plot)), squeeze(POISSON_DATA(:,:,struct_idx_to_plot))))
% 
% fig = figure();
% ax = axes(fig);
% hold on
% for eig_idx_to_plot = 1:N_eig
%     wv_plot = squeeze(WAVEVECTOR_DATA(:,:,struct_idx_to_plot));
%     fr_plot = squeeze(EIGENVALUE_DATA(:,eig_idx_to_plot,struct_idx_to_plot));
%     plot_dispersion_surface(wv_plot,fr_plot,[],[],ax);
% end
% view(3)