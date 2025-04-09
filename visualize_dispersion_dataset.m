% Housekeeping
clc; clear; close all;

% Load design dataset
isContour = false;
dataset_tag = 'control';
load_file = ['datasets/dispersion/' dataset_tag '.mat'];
load(load_file);

% Options
isPlotWavevectors = false;
grid = [1 1];
offset = 0;

% Dispersion data
N_design = size(designs,4);
N_eig = size(EIGENVALUE_DATA,2);
wv = WAVEVECTOR_DATA;

% Plot the dispersions
fig = figure();
ars.magicPlotLocal(fig);
set(fig,'defaultAxesFontSize',20)
subax = axes(fig);
t = tiledlayout(grid(1),grid(2));
t.Padding = 'compact';
for row = 1:grid(1)
    for col = 1:grid(2)
        subax(row,col) = nexttile;
        design_idx = offset + sub2ind(grid,row,col);
        ev = squeeze(EIGENVALUE_DATA(:,:,design_idx));
        if isContour == false
            plot_dispersion_surface(wv,ev,const.N_wv(1),const.N_wv(2),subax(row,col));
        else
            wn = repmat(contour_info.wavenumber,1,const.N_eig);
            plot_dispersion_curve(wn,ev,contour_info,subax(row,col));
        end
    end
end

% Plot the wavevectors
if isPlotWavevectors == true
    fig = figure();
    ars.magicPlotLocal(fig);
    set(fig,'defaultAxesFontSize',24)
    ax = axes(fig);
    plot_wavevectors(const.wavevectors,ax);
end