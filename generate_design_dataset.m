function generate_design_dataset(design_tag, N_design, sigma_f, sigma_l, offset, isDisplay)

% Defaults arguments
arguments
    design_tag char = 'control';    % name of dataset
    N_design double = 100;          % 100 - number of designs 
    sigma_f double = 1;             % 1 - kernel standard deviation
    sigma_l double = 0.5;           % 0.5 - kernel length scale
    offset double = 0;              % 0 - random seed offset
    isDisplay logical = true;       % true - whether a display is available
end

% Storage Location
save_folder = 'datasets/design/';
isSaveOutput = true;

% Design parameters
design_params = design_parameters;
design_params.design_style = 'kernel';          % kernel    - method for generating design
design_params.N_pix = 32;                       % 32        - number of pixels along edge

% Universal design options
design_options.symmetry_type = 'p4mm';          % p4mm      - none or c1m1 or pmm or p4mm
design_options.N_value = inf;                   % inf       - discretization of material gradient
design_options.offset = offset;                 % 0         - random seed offset

% Kernel design options
design_options.kernel = 'periodic';             % periodic  - matern52 or periodic
design_options.sigma_f = sigma_f;               % 1         - standard deviation
design_options.sigma_l = sigma_l;               % 0.5       - length scale

% Gaussian design options
design_options.thresholds = [0 0];              % field cuts
design_options.lambda = 0.5;                    % length scale

% QR code design options
design_options.min_logF = 0.6;                  % minimum of uniform frequency distribution  
design_options.max_logF = 1.6;                  % maximum of uniform frequency distribution
design_options.N_Fx = 4;                        % number of randomly sampled x frequencies
design_options.N_Fy = 4;                        % number of randomly sampled y frequencies
design_options.fudge = 0.06;                    % length scale of fudging
design_options.fill = 'min';                    % material type for fudging

% Apply design options
design_params.design_options = design_options;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot example design
if isDisplay == true
    fig = figure();
    ars.magicPlotLocal(fig);
    dp = design_params;
    dp.design_number = 1;
    dp = dp.prepare();
    design = get_design(dp);
    plot_design(design,fig);
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Dataset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% start parallel pool
if isempty(gcp('nocreate')); parpool; end

% If not saving, warn user
if isSaveOutput == false
    warning('isSaveOutput is set to false. Output will not be saved.')
end

% Generate designs
tic
designs = zeros(design_params.N_pix,design_params.N_pix,3,N_design);
parfor i = 1:N_design
    pfdp = design_params;
    pfdp.design_number = i;
    pfdp = pfdp.prepare();
    designs(:,:,:,i) = get_design(pfdp);
end
toc

% Save the data
if isSaveOutput == true
    vars_to_save = {'design_params','designs'};
    ars.createSafeFold(save_folder)
    save_file = [save_folder design_tag '.mat'];
    save(save_file,vars_to_save{:},'-v7.3');
end