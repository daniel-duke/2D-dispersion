function generate_dispersion_dataset(design_tag, isDisplay)

% Defaults arguments
arguments
    design_tag char = 'control';
    isDisplay logical = true;
end

% Load design dataset
load_folder = 'datasets/design/';
load_file = [load_folder design_tag '.mat'];
load(load_file);

% Storage location
dispersion_tag = design_tag;
save_folder = 'datasets/dispersion/';
isSaveOutput = true;

% Subsample the designs for faster debugging
downsample_factor = 1;
designs = designs(:,:,:,1:downsample_factor:end);

% Analysis flags
design_idx_to_plot = 1;
isPlotWavevectors = false;
isPlotDesign = false;
isPlotDispersion = true;
isProfile = false;

% Dispersion parameters and flags
N_design = size(designs,4);                 % number of designs to calculate the dispersion relation for
const.N_pix = size(designs,1);              % number of pixels along each side of the unit cell (currently still requires unit cell to have same number of pixels along each side)
const.N_ele = 1;                            % 1  - number of elements along the side of each pixel (i.e. N_ele = 2 --> 4 elements per pixel, N_ele = 3 --> 9 elements per pixel)
const.N_k = 21;                             % 21 - number of wavevectors in x direction of the IBZ discretization (used for full IBZ calculations)
const.N_eig = 6;                            % 6  - number of dispersion bands to comptue
const.sigma_eig = 1;                        % leave this as 1 (eigensolver looks for eigenvalues around this value. Unless material properties get crazy (super high density, super low modulus), this should work fine)
const.design_scale = 'linear';              % leave this as linear (scaling gradient between min and max material)
const.isUseImprovement = true;              % Leave this as true (whether to use "VEC" matrices)
const.isUseSecondImprovement = false;       % Leave this as false (whether to use "VEC_simplified" matrices)
const.isUseParallel = true;                 % Leave this as true (parallelize dispersion loop; structure loop is already parallelized)
const.isSaveEigenvectors = false;           % Leave this as false (whether to save the eigenvectors)

% Dispersion2 flags
const.isUseDispersion2 = false;
const.isComputeFrequencyDesignSensitivity = false;
const.isComputeGroupVelocity = false;
const.isComputeGroupVelocityDesignSensitivity = false;

% Material properties
const.a = 1;                                % 1     - [m], side length of the unit cell
const.E_min = 2e9;                          % 2e9   - [Pa], modulus of min material
const.E_max = 200e9;                        % 200e9 - [Pa], modulus of max material
const.rho_min = 1e3;                        % 1e3   - [kg/m^3], density of min material
const.rho_max = 8e3;                        % 8e3   - [kg/m^3], density of max material
const.poisson_min = 0.3;                    % 0.3   - Poisson's ratio of min material
const.poisson_max = 0.3;                    % 0.3   - Poisson's ratio of max mateiral
const.t = 1;                                % Leave as 1 (irrelevant parameter for dynamics)

% Symmetry and wavevector parameters
isUseContour = false;
symmetry_type = 'none';
if isUseContour == false
    const.N_wv(1) = const.N_k;
    const.N_wv(2) = ceil(const.N_wv(1)/2);
    const.wavevectors = get_IBZ_wavevectors(const.N_wv,const.a,symmetry_type);
else
    [const.wavevectors,contour_info] = get_IBZ_contour_wavevectors(const.N_k,const.a,symmetry_type);
    const.N_wv(1) = size(const.wavevectors,1);
    const.N_wv(2) = 1;
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot chosen design
if isPlotDesign == true && isDisplay == true
    fig = figure();
    ars.magicPlotLocal(fig);
    plot_design(designs(:,:,:,design_idx_to_plot),fig);
end

% Plot the wavevectors
if isPlotWavevectors == true && isDisplay == true
    fig = figure();
    ars.magicPlotLocal(fig);
    ax = axes(fig);
    plot_wavevectors(const.wavevectors,ax);
end

% Plot chosen dispersion relation
if isPlotDispersion == true && isDisplay == true
    fig = figure();
    ars.magicPlotLocal(fig);
    ax = axes(fig);
    const.design = designs(:,:,:,design_idx_to_plot);
    if const.isUseDispersion2 == false
        [fr,~] = dispersion(const,const.wavevectors);
    else
        [fr,~] = dispersion2(const,const.wavevectors);
    end
    if isUseContour == false
        plot_dispersion_surface(const.wavevectors,fr,const.N_wv(1),const.N_wv(2),ax);
    else
        wn = repmat(contour_info.wavenumber,1,const.N_eig);
        plot_dispersion_curve(wn,fr,contour_info,ax);
    end
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

% Start profiling
if isProfile == true && isDisplay == true
    mpiprofile on
end

% Initialize storage arrays
WAVEVECTOR_DATA = const.wavevectors;
EIGENVALUE_DATA = zeros(prod(const.N_wv),const.N_eig,N_design);
EIGENVECTOR_DATA = zeros(prod(const.N_wv),const.N_eig,N_design);
MODULUS_DATA = zeros(const.N_pix,const.N_pix,N_design);
DENSITY_DATA = zeros(const.N_pix,const.N_pix,N_design);
POISSON_DATA = zeros(const.N_pix,const.N_pix,N_design);

% Create waitbar
if isDisplay == true
    pfwb = filex.parfor_wait(N_design,'Waitbar',true);
end

% Loop over designs
tic
for design_idx = 1:N_design
    % Parfor varaibles
    pfc = const;

    % Assign the current design to const
    pfc.design = designs(:,:,:,design_idx);

    % Solve the dispersion problem
    if const.isUseDispersion2 == false
        [fr,ev] = dispersion(pfc,pfc.wavevectors);
    else
        [fr,ev] = dispersion2(pfc,pfc.wavevectors);
    end

    % Save data
    EIGENVALUE_DATA(:,:,design_idx) = real(fr);
    if pfc.isSaveEigenvectors
        EIGENVECTOR_DATA(:,:,:,design_idx) = ev;
    end

    % Save the material properties
    MODULUS_DATA(:,:,design_idx) = pfc.E_min + (pfc.E_max - pfc.E_min)*pfc.design(:,:,1);
    DENSITY_DATA(:,:,design_idx) = pfc.rho_min + (pfc.rho_max - pfc.rho_min)*pfc.design(:,:,2);
    POISSON_DATA(:,:,design_idx) = pfc.poisson_min + (pfc.poisson_max - pfc.poisson_min)*pfc.design(:,:,3);

    % Updated waitbar
    if isDisplay == true; pfwb.Send; end
end
if isDisplay == true; pfwb.Destroy; end
toc

% View profiling
if isProfile == true && isDisplay == true
    mpiprofile viewer
end

% Save the results
if isSaveOutput == true
    vars_to_save = {'design_params','designs','const','MODULUS_DATA','DENSITY_DATA','POISSON_DATA','WAVEVECTOR_DATA','EIGENVALUE_DATA'};
    if const.isSaveEigenvectors
        vars_to_save = [vars_to_save,{'EIGENVECTOR_DATA'}];
    end
    if exist('dataset_index','var')
        vars_to_save = [vars_to_save,{'dataset_index','design_params_arr'}];
    end
    ars.createSafeFold(save_folder)
    save_file = [save_folder dispersion_tag '.mat'];
    save(save_file,vars_to_save{:});
end