% Housekeeping
clear; close all;

% Load design dataset
dataset_tag = 'control_big_nosym';
load_file = ['../datasets/design_datasets/design_' dataset_tag '.mat'];
load(load_file);

% Pick dimensions of design tiling
design_idx_to_plot = 1;
N_design = [3 3];

% Plot the designs
fig = figure();
ax = axes(fig);
imagesc(repmat(squeeze(designs(:,:,1,design_idx_to_plot)),N_design(1),N_design(2)))
set(ax,'XTick',[])
set(ax,'YTick',[])
daspect([1 1 1])
colormap('gray')