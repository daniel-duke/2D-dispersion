% Housekeeping
clc; clear; close all;

% Load dispersion dataset
dispersion_tag = 'test';
load_file = ['./dispersion_datasets/' dispersion_tag '/dispersion_dataset_' dispersion_tag '.mat'];
load(load_file)

% Storage Location
complete_tag = dispersion_tag;
save_file = ['./complete_datasets/complete_dataset_' complete_tag];
isSaveOutput = false;

% What to do
isSaveFigures = false;
isPlotBandgapDist = true;
isPlotBandgaps = true;
isPlotDesign = true;
isPlotDispersion = false;

% Plotting parameters
max_bandgap_width = 800;
max_bandgap_location = 2400;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Dataset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If not saving, warn user
if isSaveOutput == false
    warning('isSaveOutput is set to false. Output will not be saved.')
end

% Bandgap analyis
[bandgap_widths,bandgap_locations] = calc_bandgaps(EIGENVALUE_DATA);
success_rate = sum(sum(bandgap_widths)>0)/length(bandgap_widths);

% Save output
if isSaveOutput == true
    vars_to_save = {'design_params','designs','const','ELASTIC_MODULUS_DATA', 'DENSITY_DATA', 'POISSON_DATA', 'WAVEVECTOR_DATA','EIGENVALUE_DATA','bandgap_widths','bandgap_locations'};
    save(save_file,vars_to_save{:});
end 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Bandgap width
if isPlotBandgapDist == true
    fig = figure();
    magic_plot_local(fig);
    ax = axes(fig);
    plot_bandgap_dist(bandgap_widths,max_bandgap_width,ax)
    if isSaveFigures == true
        saveas(fig,['./figures/' complete_tag '_gapDistribution.png'])
    end
end

% Bandgap location
if isPlotBandgaps == true
    fig = figure();
    magic_plot_local(fig);
    ax = axes(fig);
    plot_bandgaps(bandgap_widths,bandgap_locations,max_bandgap_width,max_bandgap_location,ax)
    if isSaveFigures == true
        saveas(fig,['./figures/' complete_tag '_gapLocations.png'])
    end
end

% Plot chosen design
if isPlotDesign == true
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
    if isSaveFigures == true
        saveas(fig,['./figures/' complete_tag '_design.png'])
    end

    % Design image
    if isSaveFigures == true
        fig = figure('Visible','off');
        ax = axes(fig);
        imagesc(squeeze(designs(:,:,1,design_idx_to_plot)))
        set(ax,'XTick',[])
        set(ax,'YTick',[])
        colormap('gray')
        daspect([1 1 1])
        imwrite(frame2im(getframe(ax)),['./figures/' complete_tag '_modulus.png'])
    end
end

% Plot chosen dispersion relation
if isPlotDispersion == true
    % Pick design to plot
    design_idx_to_plot = 1;

    % Dispersion data
    N_eig = size(EIGENVALUE_DATA,2);
    wv = squeeze(WAVEVECTOR_DATA(:,:,design_idx_to_plot));
    ev = squeeze(EIGENVALUE_DATA(:,:,design_idx_to_plot));
    
    % Plot dispersion surface
    fig = figure();
    magic_plot_local(fig);
    ax = axes(fig);
    plot_dispersion_surface(wv,ev,const.N_wv(1),const.N_wv(2),ax);
    if isSaveFigures == true
        saveas(fig,['./figures/' complete_tag '_dispersion.png'])
    end
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bandgap_widths,bandgap_locations] = calc_bandgaps(eigs)
    N_struct = size(eigs,3);
    N_eig = size(eigs,2);
    bandgap_widths = zeros(N_eig-1,N_struct);
    bandgap_locations = zeros(N_eig-1,N_struct);
    for struct_idx = 1:N_struct
        for eig_pair_idx = 1:N_eig-1
            lower_band_max = max(eigs(:,eig_pair_idx,struct_idx));
            upper_band_min = min(eigs(:,eig_pair_idx+1,struct_idx));
            bandgap_widths(eig_pair_idx,struct_idx) = max(0,upper_band_min-lower_band_max);
            if bandgap_widths(eig_pair_idx,struct_idx) > 0
                bandgap_locations(eig_pair_idx,struct_idx) = (lower_band_max+upper_band_min)/2;
            end
        end
    end
end

function plot_bandgap_dist(bandgap_widths,max_bandgap_width,ax)
    bandgap_max_widths = max(bandgap_widths);
    histogram(ax,bandgap_max_widths(bandgap_max_widths>0),'BinEdges',linspace(0,max_bandgap_width,max_bandgap_width/100+1))
    xlim([0 max_bandgap_width])
    ylim([0 20])
    xlabel("Bandgap Width [Hz]")
end

function plot_bandgaps(bandgap_widths,bandgap_locations,max_bandgap_width,max_bandgap_location,ax)
    N_struct = size(bandgap_widths,2);
    N_eig_pair = size(bandgap_widths,1);
    cmap = flipud(colormap);
    hold on
    for struct_idx = 1:N_struct
        for eig_pair_idx = 1:N_eig_pair
            if bandgap_widths(eig_pair_idx,struct_idx) > 0
                y_upper = bandgap_locations(eig_pair_idx,struct_idx) + bandgap_widths(eig_pair_idx,struct_idx)/2;
                y_lower = bandgap_locations(eig_pair_idx,struct_idx) - bandgap_widths(eig_pair_idx,struct_idx)/2;
                bandgap_ratio = min(1,bandgap_widths(eig_pair_idx,struct_idx)/max_bandgap_width);
                color_idx = round(bandgap_ratio*(size(cmap,1)-1))+1;
                fill(ax,[0,1,1,0], [y_lower, y_lower, y_upper, y_upper], cmap(color_idx,:), 'FaceAlpha', 10/N_struct, 'EdgeColor', 'none');
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