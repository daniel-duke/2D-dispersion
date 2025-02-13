% Housekeeping
clear; close all;

% Load design dataset
dataset_tag = 'test';
load_file = ['../datasets/design/' dataset_tag '.mat'];
load(load_file);

% Pick dimensions of design tiling
design_idx_to_plot = 1;
N_design = [1 1];

% Noise the image
sigma = 10;
cap = false;
design_plot = repmat(squeeze(designs(:,:,1,design_idx_to_plot)),N_design(1),N_design(2));
for i = 1:design_params.N_pix
    for j = 1:design_params.N_pix
        if cap == true
            design_plot(i,j) = max(0,min(1,design_plot(i,j) + normrnd(0,sigma)));
        else
            design_plot(i,j) = design_plot(i,j) + normrnd(0,sigma);
        end
    end
end

% Plot the designs
fig = figure();
ax = axes(fig);
imagesc(design_plot)
set(ax,'XTick',[])
set(ax,'YTick',[])
daspect([1 1 1])
colormap('gray')