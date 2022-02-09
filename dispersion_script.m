clear; close all; %delete(findall(0));
script_start_time = replace(char(datetime),':','-');

isSaveOutput = false;

% Dispersion computation
dispersion_computation = DispersionComputation;

% Dispersion computation parameters
dcp = DispersionComputationParameters;
dcp.N_wv = [16 31];
dcp.N_eig = 3;
dcp.N_ele = 1;
dcp.N_pix = [16 16]; % Must be square for now. Future improvement could allow non-square unit cells and/or non-square elements.
dcp.sigma_eig = 1;
dcp.isUseParallel = true;
dcp.isUseImprovement = true;
dcp.isUseGPU = false;
dispersion_computation.dispersion_computation_parameters = dcp;

% Design generator
dg = DesignGenerator;
dg.kernel_name = 'periodic';
kp = PeriodicKernelParameters;
kp.sigma_f = 1;
kp.length_scale = .5;
kp.period = 1;
dg.kernel_params = kp;
dg.plane_symmetry_group = 'none';
dg.N_pix = dcp.N_pix;
dg.N_value = 2; % Number of distinct material properties allowed
dg.isBoringPoisson = true; % Set poisson = 0.3?

% Design variable interpretation
dvi = DesignVariableInterpreter;
dvi.design_variable_scaling = 'log';
dvi.lattice_length = .01; % [m]
dvi.thickness = .01; % [m]
dvi.E_min = 200e6; % [Pa]
dvi.E_max = 200e9; % [Pa]
dvi.rho_min = 8e2; % [kg/m^3]
dvi.rho_max = 8e3; % [kg/m^3]
dvi.nu_min = 0; % [-]
dvi.nu_max = 0.5; % [-]
dispersion_computation.design_variable_interpreter = dvi;

% Design variable
design_number = 15;
dv = dg.generate(design_number); % This always generates designs in the 'linear' design_variable_scaling. A probability distribution in linear space won't look like a uniform distribution in log space.
dv = convert_design_variable(dv,'linear',dvi.design_variable_scaling,dvi);
dispersion_computation.design_variable = dv;

ibz_contour = get_IBZ_contour(dcp.N_wv(1),dvi.lattice_length,dg.plane_symmetry_group);
dispersion_computation.wavevector = ibz_contour.wavevector;

%% Plot the design
fig = plot_design(dv,dvi);

%% Solve the dispersion problem
dispersion_computation = dispersion_computation.run();

%% Plot the discretized Irreducible Brillouin Zone
fig = plot_wavevectors(dispersion_computation.wavevector);

%% Plot the dispersion relation
fig = plot_dispersion(ibz_contour.wavevector_parameter,dispersion_computation.frequency,ibz_contour.N_segment);

