% Housekeeping
clc; clear; close all;

% Load design dataset
data_type = "design";
dataset_tags = ["test","testy"];
N_dataset = length(dataset_tags);
load_files = strings(1,N_dataset);
for i = 1:N_dataset
    load_files(i) = "../datasets/" + data_type + ...
                    "s/" + dataset_tags(i) + ".mat";
end

% Storage location
combined_tag = "combo";
save_file = "../datasets/" + data_type + ...
            "_datasets/" + data_type + ...
            "_" + combined_tag + ".mat";

%%% load first dataset
load(load_files(1));
design_params_arr = createArray(1,N_dataset,"design_parameters");
design_params_arr(1) = design_params;
breakdown = zeros(1,N_dataset);
breakdown(1) = size(designs,4);
if data_type == "dispersion"
    const_arr(N_dataset) = struct();
    const_arr(1) = const;
end

%%% load other datasets, if the necessary parameters match
for i = 2:N_dataset
    data_add = load(load_files(i));

    %%% check design parameters
    if data_add.design_params.N_pix ~= design_params.N_pix
        error("Mismatch in number of pixels.")
    end

    %%% add design data
    design_params_arr(i) = data_add.design_params;
    breakdown(i) = size(data_add.designs,4);
    designs = cat(4,designs,data_add.designs);

    %%% only if dispersion data included
    if data_type == "dispersion"

        %%% check design parameters
        if data_add.const.N_k ~= const.N_k
            error("Mismatch in number of wavevectors.")
        end
        if data_add.const.N_eig ~= const.N_eig
            error("Mismatch in number of eigenvectors.")
        end

        %%% add dispersion data
        ELASTIC_MODULUS_DATA = cat(3,ELASTIC_MODULUS_DATA,data_add.ELASTIC_MODULUS_DATA);
        DENSITY_DATA = cat(3,DENSITY_DATA,data_add.DENSITY_DATA);
        POISSON_DATA = cat(3,POISSON_DATA,data_add.POISSON_DATA);
        WAVEVECTOR_DATA = cat(3,WAVEVECTOR_DATA,data_add.WAVEVECTOR_DATA);
        EIGENVALUE_DATA = cat(3,EIGENVALUE_DATA,data_add.EIGENVALUE_DATA);
    end
end

% Save the results
vars_to_save = {'design_params_arr','breakdown','designs'};
if data_type == "dispersion"
    vars_to_save = [vars_to_save,{'ELASTIC_MODULUS_DATA','DENSITY_DATA','POISSON_DATA','WAVEVECTOR_DATA','EIGENVALUE_DATA'}];
end
save(save_file,vars_to_save{:});
