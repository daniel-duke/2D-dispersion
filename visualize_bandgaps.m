% Housekeeping
clc; clear; close all;

% Load complete dataset
complete_tag = 'control_N10000';
load_folder = 'datasets/complete/';
load_file = [load_folder complete_tag '.mat'];
load(load_file)
disp("Data loaded...")

% Plotting parameters
max_bandgap_width = 800;
max_bandgap_location = 2900;
histogram_bin_width = 25;
locations_bar_width = 20;
isSaveFigures = false;

% Trim to just largest bandgaps
N_design = size(bandgap_widths,2);
largest_bandgap_widths = zeros(1,N_design);
largest_bandgap_locations = zeros(1,N_design);
for i = 1:N_design
    [m,mi] = max(bandgap_widths(:,i));
    if m > 0
        largest_bandgap_widths(i) = bandgap_widths(mi,i);
        largest_bandgap_locations(i) = bandgap_locations(mi,i);
    end
end

% Get averages
mean_largest_bandgap_width = mean(largest_bandgap_widths(largest_bandgap_widths>0));
mean_largest_bandgap_location = mean(largest_bandgap_locations(largest_bandgap_widths>0));

% Bandgap width histogram
fig = figure();
ars.magicPlotLocal(fig);
ax = axes(fig);
plot_bandgap_hist(largest_bandgap_widths,max_bandgap_width,histogram_bin_width,mean_largest_bandgap_width,ax)
if isSaveFigures == true
    saveas(fig,['./figures/' complete_tag '_gapHist.png'])
end

% Bandgap locations
fig = figure();
ars.magicPlotLocal(fig);
ax = axes(fig);
plot_bandgaps(largest_bandgap_widths,largest_bandgap_locations,max_bandgap_width,max_bandgap_location,locations_bar_width,mean_largest_bandgap_location,ax)
if isSaveFigures == true
    saveas(fig,['./figures/' complete_tag '_gapLocs.png'])
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Bandgap width histogram
function plot_bandgap_hist(bandgap_widths,max_bandgap_width,bin_width,mean_line,ax)
    if size(bandgap_widths,1) > 1
        bandgap_widths = max(bandgap_widths);
    end
    histogram(ax,bandgap_widths(bandgap_widths>0),'BinEdges',linspace(0,max_bandgap_width,max_bandgap_width/bin_width+1))
    xline(ax,mean_line,'k','LineWidth',2)
    ax.FontSize = 20;
    xlim([0 max_bandgap_width])
    xlabel("Bandgap Width [Hz]")
end

% Bandgap locations
function plot_bandgaps(bandgap_widths,bandgap_locations,max_bandgap_width,max_bandgap_location,bar_width,mean_line,ax)
    N_design = size(bandgap_widths,2);
    N_eig_pair = size(bandgap_widths,1);
    bins_bandgap_sum = zeros(1,max_bandgap_location);
    bins_bandgap_count = zeros(1,max_bandgap_location);
    for design_idx = 1:N_design
        for eig_pair_idx = 1:N_eig_pair
            if bandgap_widths(eig_pair_idx,design_idx) > 0
                i_upper = min( max_bandgap_location, ceil(bandgap_locations(eig_pair_idx,design_idx) + bar_width/2) );
                i_lower = max( 1, ceil(bandgap_locations(eig_pair_idx,design_idx) - bar_width/2) );
                bins_bandgap_sum(i_lower:i_upper) = bins_bandgap_sum(i_lower:i_upper) + bandgap_widths(eig_pair_idx,design_idx);
                bins_bandgap_count(i_lower:i_upper) = bins_bandgap_count(i_lower:i_upper) + 1;
            end
        end
    end
    cmap = flipud(colormap);
    hold on
    for i = 1:max_bandgap_location
        if bins_bandgap_count(i) > 0
            bin_bandgap_avg = bins_bandgap_sum(i)/bins_bandgap_count(i);
            bandgap_ratio = min(1,bin_bandgap_avg/max_bandgap_width);
            color_idx = round(bandgap_ratio*(size(cmap,1)-1))+1;
            fill(ax, [i-1,i-1,i,i], [0,1,1,0], cmap(color_idx,:), 'FaceAlpha', 1, 'EdgeColor', 'none');
        end
    end
    xline(ax,mean_line,'--k','LineWidth',2)
    hold off
    xlim([0 max_bandgap_location])
    xlabel("Bandgap Location [Hz]")
    set(ax,'YTick',[])
    ax.FontSize = 20;
    clim([0 max_bandgap_width]);
    cbar = colorbar('colormap',cmap);
    cbar.Label.String  = "Bandgap Width [Hz]";
    cbar.Label.Interpreter = ax.TickLabelInterpreter;
    cbar.TickLabelInterpreter = ax.TickLabelInterpreter;
    cbar.FontSize = ax.FontSize;
end