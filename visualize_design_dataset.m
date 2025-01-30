% Housekeeping
clear; close all;

% Load design dataset
dataset_tag = 'control';
load_file = ['./design_datasets/design_' dataset_tag '.mat'];
load(load_file);

% Pick dimensions of design tiling
N_design = size(designs,4);
grid = [4 6];

% Plot the designs
fig = figure();
subax = axes(fig);
t = tiledlayout(grid(1),grid(2));
t.Padding = 'compact';
for row = 1:grid(1)
    for col = 1:grid(2)
        subax(row,col) = nexttile;
        % design_idx = sub2ind(N_design,row,col);
        design_idx = randi(N_design);
        imagesc(squeeze(designs(:,:,1,design_idx)))
        set(subax(row,col),'XTick',[])
        set(subax(row,col),'YTick',[])
        daspect([1 1 1])
    end
end
colormap('gray')