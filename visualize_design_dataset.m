% Housekeeping
clear; close all;

% Load design dataset
dataset_tag = 'control_32pix_corr05_p4mm_semicont';
load_file = ['./design_datasets/design_dataset_' dataset_tag '.mat'];
design_data = load(load_file);
designs = design_data.designs;

% Pick dimensions of design tiling
N_design = [4 6];

% Plot the designs
fig = figure();
subax = axes(fig);
t = tiledlayout(N_design(1),N_design(2));
t.Padding = 'compact';
for row = 1:N_design(1)
    for col = 1:N_design(2)
        subax(row,col) = nexttile;
        design_idx = sub2ind(N_design,row,col);
        imagesc(squeeze(designs(:,:,1,design_idx)))
        set(subax(row,col),'XTick',[])
        set(subax(row,col),'YTick',[])
        daspect([1 1 1])
    end
end
colormap('gray')