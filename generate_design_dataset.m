% Housekeeping
clc; clear; close all;

% Storage Location
design_tag = 'control';
save_file = ['./design_datasets/design_dataset_' design_tag];
isSaveOutput = true;

% Size of dataset
N_design = 1000;

% Design parameters
design_params = design_parameters;
design_params.design_style = 'kernel';
design_params.N_pix = 16;

% Universal design options
design_options.symmetry_type = 'p4mm';      % none or c1m1 or pmm or p4mm
design_options.N_value = inf;               % discretization of material gradient
design_options.offset = 0;                  % random seed offset

% Kernel design options
design_options.kernel = 'periodic';         % matern52 or periodic
design_options.sigma_f = 1;                 % standard deviation
design_options.sigma_l = 0.5;                 % length scale

% Gaussian design options
design_options.thresholds = [0 0];          % field cuts
design_options.lambda = 0.5;                % length scale

% QR code design options
design_options.min_logF = 0.6;              % minimum of uniform frequency distribution  
design_options.max_logF = 1.6;              % maximum of uniform frequency distribution
design_options.N_Fx = 4;                    % number of randomly sampled x frequencies
design_options.N_Fy = 4;                    % number of randomly sampled y frequencies
design_options.fudge = 0.06;                % length scale of fudging
design_options.fill = 'min';                % material type for fudging

% Apply design options
design_params.design_options = design_options;

% Plot example design
fig = figure();
magic_plot_local(fig);
dp = design_params;
dp.design_number = 1;
dp = dp.prepare();
design = get_design(dp);
fig = plot_design(design,fig);

% Generate designs
designs = zeros(design_params.N_pix,design_params.N_pix,3,N_design);
parfor i = 1:N_design
    pfdp = design_params;
    pfdp.design_number = i;
    pfdp = pfdp.prepare();
    designs(:,:,:,i) = get_design(pfdp);
end

% Save the data
if isSaveOutput == true
    save(save_file,'design_params','designs');
end
