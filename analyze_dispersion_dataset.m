% Housekeeping
clc; clear; close all;

% Load dispersion dataset
dispersion_tag = 'control_sigF02_sigLCombo';
load_folder = 'datasets/dispersion/';
load_file = [load_folder dispersion_tag '.mat'];
load(load_file)

% Storage Location
complete_tag = dispersion_tag;
save_folder = 'datasets/complete/';
isSaveOutput = true;

% Trimming parameters
ideal_success_rate = 0;

% What to do
isSaveFigures = false;
isPlotBandgapDist = true;
isPlotBandgaps = true;
isPlotDesign = false;
isPlotDispersion = false;

% Plotting parameters
min_bandgap_width = 50;
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
[bandgap_widths,bandgap_locations] = calc_bandgaps(EIGENVALUE_DATA,min_bandgap_width);
success_rate = sum(sum(bandgap_widths)>0)/length(bandgap_widths);

% Trimming
if success_rate < ideal_success_rate
    idxs_trimmed = trim_datset(bandgap_widths,ideal_success_rate);
    designs = designs(:,:,:,idxs_trimmed);
    MODULUS_DATA = MODULUS_DATA(:,:,idxs_trimmed);
    DENSITY_DATA = DENSITY_DATA(:,:,idxs_trimmed);
    POISSON_DATA = POISSON_DATA(:,:,idxs_trimmed);
    EIGENVALUE_DATA = EIGENVALUE_DATA(:,:,idxs_trimmed);
    bandgap_widths = bandgap_widths(:,idxs_trimmed);
    bandgap_locations = bandgap_locations(:,idxs_trimmed);
    success_rate = sum(sum(bandgap_widths)>0)/length(bandgap_widths);
end

% Save output
if isSaveOutput == true
    vars_to_save = {'design_params','designs','const','MODULUS_DATA', 'DENSITY_DATA', 'POISSON_DATA', 'WAVEVECTOR_DATA','EIGENVALUE_DATA','bandgap_widths','bandgap_locations','success_rate'};
    if exist('dataset_index','var')
        vars_to_save = [vars_to_save,{'dataset_index','design_params_arr'}];
    end
    if exist('const_arr','var')
        vars_to_save = [vars_to_save,{'const_arr'}];
    end
    ars.createSafeFold(save_folder)
    save_file = [save_folder complete_tag '.mat'];
    save(save_file,vars_to_save{:});
end 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Bandgap width
if isPlotBandgapDist == true
    fig = figure();
    ars.magicPlotLocal(fig);
    ax = axes(fig);
    plot_bandgap_dist(bandgap_widths,max_bandgap_width,ax)
    if isSaveFigures == true
        saveas(fig,['./figures/' complete_tag '_gapDistribution.png'])
    end
end

% Bandgap location
if isPlotBandgaps == true
    fig = figure();
    ars.magicPlotLocal(fig);
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
    modulus = squeeze(MODULUS_DATA(:,:,design_idx_to_plot));
    density = squeeze(DENSITY_DATA(:,:,design_idx_to_plot));
    poisson = squeeze(POISSON_DATA(:,:,design_idx_to_plot));
    modulus = (modulus-ars.myMin(modulus))/(ars.myMax(modulus)-ars.myMin(modulus));
    density = (density-ars.myMin(density))/(ars.myMax(density)-ars.myMin(density));
    poisson = (poisson-ars.myMin(poisson))/(ars.myMax(poisson)-ars.myMin(poisson));
    
    % Plot design
    fig = figure();
    ars.magicPlotLocal(fig);
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
    wv = WAVEVECTOR_DATA;
    ev = squeeze(EIGENVALUE_DATA(:,:,design_idx_to_plot));
    
    % Plot dispersion surface
    fig = figure();
    ars.magicPlotLocal(fig);
    ax = axes(fig);
    plot_dispersion_surface(wv,ev,const.N_wv(1),const.N_wv(2),ax);
    if isSaveFigures == true
        saveas(fig,['./figures/' complete_tag '_dispersion.png'])
    end
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bandgap_widths,bandgap_locations] = calc_bandgaps(eigs,min_bandgap_width)
    N_design = size(eigs,3);
    N_eig = size(eigs,2);
    bandgap_widths = zeros(N_eig-1,N_design);
    bandgap_locations = zeros(N_eig-1,N_design);
    for design_idx = 1:N_design
        for eig_pair_idx = 1:N_eig-1
            lower_band_max = max(eigs(:,eig_pair_idx,design_idx));
            upper_band_min = min(eigs(:,eig_pair_idx+1,design_idx));
            if upper_band_min-lower_band_max > min_bandgap_width
                bandgap_widths(eig_pair_idx,design_idx) = upper_band_min-lower_band_max;
                bandgap_locations(eig_pair_idx,design_idx) = (lower_band_max+upper_band_min)/2;
            end
        end
    end
end

function idxs_trimmed = trim_datset(bandgap_widths,ideal_success_rate)
    N_design = size(bandgap_widths,2);
    N_bandgap = sum(sum(bandgap_widths)>0);
    N_design_trimmed = floor(N_bandgap/ideal_success_rate);
    idxs_trimmed = zeros(1,N_design_trimmed);
    failure_count = 0;
    trimmed_count = 0;
    for i = 1:N_design
        if sum(bandgap_widths(:,i)) > 0
            trimmed_count = trimmed_count + 1;
            idxs_trimmed(trimmed_count) = i;
        elseif failure_count < N_design_trimmed-N_bandgap
            failure_count = failure_count + 1;
            trimmed_count = trimmed_count + 1;
            idxs_trimmed(trimmed_count) = i;
        end
    end
end

function plot_bandgap_dist(bandgap_widths,max_bandgap_width,ax)
    bandgap_max_widths = max(bandgap_widths);
    histogram(ax,bandgap_max_widths(bandgap_max_widths>0),'BinEdges',linspace(0,max_bandgap_width,max_bandgap_width/10+1))
    xlim([0 max_bandgap_width])
    xlabel("Bandgap Width [Hz]")
end

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