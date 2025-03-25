% Housekeeping
clc; clear; close all;

% Load design dataset
dataset_tag = 'control_sigF20_sigL04';
load_file = ['datasets/production/dispersion/' dataset_tag '.mat'];
load(load_file);

% Dispersion data
N_design = size(designs,4);
N_eig = size(EIGENVALUE_DATA,2);
wv = WAVEVECTOR_DATA;

% Set dimensions of dispersion tiling
grid = [1 1];

% Plot the dispersions
fig = figure();
ars.magicPlotLocal(fig);
subax = axes(fig);
t = tiledlayout(grid(1),grid(2));
t.Padding = 'compact';
for row = 1:grid(1)
    for col = 1:grid(2)
        subax(row,col) = nexttile;
        design_idx = sub2ind(grid,row,col);
        ev = squeeze(EIGENVALUE_DATA(:,:,design_idx));
        plot_dispersion_surface(wv,ev,const.N_wv(1),const.N_wv(2),subax(row,col));
    end
end

