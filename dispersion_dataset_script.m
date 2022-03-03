clear; close all; %delete(findall(0));
script_start_time = replace(char(datetime),':','-');
mfilename_fullpath_var = [mfilename('fullpath') '.m'];
mfilename_var = [mfilename '.m'];

isSaveOutput = true;
isSaveEigenvectors = false;
isProfile = false;
N_dispersion_relation = 50;
dispersion_relation_index_offset = 0;

% Dispersion computation
dispersion_computation = DispersionComputation;

% Dispersion computation parameters
dcp = DispersionComputationParameters;
dcp.wavevector_array_size = [26 51];
dcp.N_band = 3;
dcp.N_element = 1;
dcp.N_pixel = [10 10]; % Must be square for now. Future improvement could allow non-square unit cells and/or non-square elements.
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

% ibz_contour = get_irreducible_brillouin_zone_contour(dcp.N_wv(1),dvi.lattice_length,dg.plane_symmetry_group);
% dispersion_computation.wavevector = ibz_contour.wavevector;
ibz = get_irreducible_brillouin_zone(dcp.wavevector_array_size,dvi.unit_cell_length,dg.plane_symmetry_group);
dispersion_computation.wavevector = ibz.wavevector;

dispersion_dataset = DispersionDataset(prod(dcp.wavevector_array_size),dcp.N_band,N_dispersion_relation);
wb = waitbar(0,'Computing dispersion dataset');
for dispersion_relation_index = 1:N_dispersion_relation
    design_number = dispersion_relation_index + dispersion_relation_index_offset;
    dv = dg.generate(design_number); % This always generates designs in the 'linear' design_variable_scaling. A probability distribution in linear space won't look like a uniform distribution in log space.
    dv = convert_design_variable(dv,'linear',dvi.design_variable_scaling,dvi);
    dispersion_computation.design_variable = dv;
    dispersion_computation = dispersion_computation.run();
    dispersion_dataset = dispersion_dataset.import_dispersion_computation(dispersion_computation,dispersion_relation_index);
    waitbar(dispersion_relation_index/N_dispersion_relation,wb,['Computing dispersion dataset' newline num2str(dispersion_relation_index) '/' num2str(N_dispersion_relation)])
end
close(wb);

if isSaveOutput
    mkdir(['OUTPUT/output ' script_start_time])
    copyfile(mfilename_fullpath_var,['OUTPUT/output ' script_start_time '/' mfilename_var]);
    dispersion_dataset.save(['OUTPUT/output ' script_start_time '/data'])
end