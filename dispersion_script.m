clear; close all; %delete(findall(0));
script_start_time = replace(char(datetime),':','-');

isUseIbzContour = false;

% Dispersion computation
dispersion_computation = DispersionComputation;

% Dispersion computation parameters
dcp = DispersionComputationParameters;
dcp.wavevector_array_size = [31 16];
dcp.N_band = 3;
dcp.N_element = 1;
dcp.N_pixel = [16 16]; % Must be square for now. Future improvement could allow non-square unit cells and/or non-square elements.
dcp.sigma_eig = 1;
dcp.isUseParallel = true;
dcp.isUseImprovement = true;
dcp.isSaveEigenvector = true;
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
dg.N_pixel = dcp.N_pixel;
dg.N_value = 2; % Number of distinct material properties allowed
dg.isBoringPoisson = true; % Set poisson = 0.3?

% Design variable interpretation
dvi = DesignVariableInterpreter;
dvi.design_variable_scaling = 'log';
dvi.unit_cell_length = .01; % [m]
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

if isUseIbzContour
    ibz_contour = get_irreducible_brillouin_zone_contour(dcp.wavevector_array_size(1),dvi.lattice_length,dg.plane_symmetry_group);
    dispersion_computation.wavevector = ibz_contour.wavevector;
else 
    ibz = get_irreducible_brillouin_zone(dcp.wavevector_array_size,dvi.unit_cell_length,dg.plane_symmetry_group);
    dispersion_computation.wavevector = ibz.wavevector;
end

%% Plot the design
fig = plot_design(dv,dvi);

%% Solve the dispersion problem
dispersion_computation = dispersion_computation.run();

%% Plot the discretized Irreducible Brillouin Zone
fig = plot_wavevectors(dispersion_computation.wavevector);

%% Plot the dispersion relation
if isUseIbzContour
     fig = plot_dispersion(ibz_contour.wavevector_parameter,dispersion_computation.frequency,ibz_contour.N_segment);
else
    fig = figure;
    tlo = tiledlayout('flow');
    for band_idx = 1:dispersion_computation.dispersion_computation_parameters.N_band
        ax = nexttile;
        wv = dispersion_computation.wavevector;
        fr = dispersion_computation.frequency(:,band_idx);
        was = dispersion_computation.dispersion_computation_parameters.wavevector_array_size;
        plot_dispersion_band(wv,fr,was,ax);
    end
end

if dcp.isSaveEigenvector
    plot_mode_ui(dispersion_computation);
end
