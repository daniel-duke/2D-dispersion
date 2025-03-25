% Housekeeping
clc; clear; close all;

% Load complete dataset
complete_tag = 'control_sigF20_sigLCombo_sr90';
load_folder = 'datasets/production/complete/';
load_file = [load_folder complete_tag '.mat'];
load(load_file)

% Plotting parameters
max_bandgap_width = 800;
max_bandgap_location = 2400;
isSaveFigures = false;

% Bandgap distribution
fig = figure();
ars.magicPlotLocal(fig);
ax = axes(fig);
plot_bandgap_dist(bandgap_widths,max_bandgap_width,ax)
if isSaveFigures == true
    saveas(fig,['./figures/' complete_tag '_gapDistribution.png'])
end

% Bandgap locations
fig = figure();
ars.magicPlotLocal(fig);
ax = axes(fig);
plot_bandgaps(bandgap_widths,bandgap_locations,max_bandgap_width,max_bandgap_location,ax)
if isSaveFigures == true
    saveas(fig,['./figures/' complete_tag '_gapLocations.png'])
end

% Bandgap distribution
function plot_bandgap_dist(bandgap_widths,max_bandgap_width,ax)
    bandgap_max_widths = max(bandgap_widths);
    histogram(ax,bandgap_max_widths(bandgap_max_widths>0),'BinEdges',linspace(0,max_bandgap_width,max_bandgap_width/10+1))
    xlim([0 max_bandgap_width])
    xlabel("Bandgap Width [Hz]")
end

% Bandgap locations
function plot_bandgaps(bandgap_widths,bandgap_locations,max_bandgap_width,max_bandgap_location,ax)
    N_design = size(bandgap_widths,2);
    N_eig_pair = size(bandgap_widths,1);
    cmap = flipud(colormap);
    transparency = 1/sqrt(10*N_design);
    hold on
    for design_idx = 1:N_design
        for eig_pair_idx = 1:N_eig_pair
            if bandgap_widths(eig_pair_idx,design_idx) > 0
                y_upper = bandgap_locations(eig_pair_idx,design_idx) + bandgap_widths(eig_pair_idx,design_idx)/2;
                y_lower = bandgap_locations(eig_pair_idx,design_idx) - bandgap_widths(eig_pair_idx,design_idx)/2;
                bandgap_ratio = min(1,bandgap_widths(eig_pair_idx,design_idx)/max_bandgap_width);
                color_idx = round(bandgap_ratio*(size(cmap,1)-1))+1;
                fill(ax,[0,1,1,0], [y_lower, y_lower, y_upper, y_upper], cmap(color_idx,:), 'FaceAlpha', transparency, 'EdgeColor', 'none');
            end
        end
    end
    hold off
    ylim([0 max_bandgap_location])
    ylabel("Bandgap Location [Hz]")
    clim([0 max_bandgap_width]);
    cbar = colorbar('colormap',cmap);
    cbar.Label.String  = "Bandgap Width [Hz]";
    cbar.Label.Interpreter = ax.TickLabelInterpreter;
    cbar.TickLabelInterpreter = ax.TickLabelInterpreter;
    cbar.FontSize = ax.FontSize;
end