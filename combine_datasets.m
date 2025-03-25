% Housekeeping
clc; clear; close all;

% Describe datasets
dataset_tags = {'control_sigF20_sigL07',...
                'control_sigF20_sigL08'};
data_type = 'dispersion';
N_dataset = length(dataset_tags);
load_files = strings(1,N_dataset);

% Load datasets
for i = 1:N_dataset
    load_files(i) = [ 'datasets/' data_type '/' ...
                      dataset_tags{i} '.mat' ];
end

% Storage location
combined_tag = 'control_sigF20_sigLCombo';
save_folder = [ 'datasets/' data_type '/' ];
save_file = [ save_folder combined_tag '.mat' ];

%%% load first dataset parameters
load(load_files(1));
dataset_index = ones(1,size(designs,4));
design_params_arr(1) = design_params;
if strcmp(data_type,'dispersion')
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
    dataset_index = cat(2,dataset_index,ones(1,size(designs,4))*i);
    design_params_arr = cat(2,design_params_arr,data_add.design_params);
    designs = cat(4,designs,data_add.designs);

    %%% only if dispersion data included
    if strcmp(data_type,'dispersion')

        %%% check design parameters
        if data_add.const.N_ele ~= const.N_ele
            error("Mismatch in number of elements.")
        end
        if data_add.const.N_k ~= const.N_k
            error("Mismatch in number of wavevectors.")
        end
        if data_add.const.N_eig ~= const.N_eig
            error("Mismatch in number of eigenvectors.")
        end
        if data_add.const.isSaveEigenvectors ~= const.isSaveEigenvectors
            error("Mismatch in saving eigenvectors.")
        end

        %%% add dispersion data
        const_arr = cat(2,const_arr,data_add.const);
        MODULUS_DATA = cat(3,MODULUS_DATA,data_add.MODULUS_DATA);
        DENSITY_DATA = cat(3,DENSITY_DATA,data_add.DENSITY_DATA);
        POISSON_DATA = cat(3,POISSON_DATA,data_add.POISSON_DATA);
        WAVEVECTOR_DATA = cat(3,WAVEVECTOR_DATA,data_add.WAVEVECTOR_DATA);
        EIGENVALUE_DATA = cat(3,EIGENVALUE_DATA,data_add.EIGENVALUE_DATA);
        if const.isSaveEigenvectors
            EIGENVECTOR_DATA = cat(3,EIGENVECTOR_DATA,data_add.EIGENVECTOR_DATA);
        end

    end
end

% Save the results
vars_to_save = {'dataset_index','design_params','design_params_arr','designs'};
if strcmp(data_type,'dispersion')
    vars_to_save = [vars_to_save,{'const','const_arr','MODULUS_DATA','DENSITY_DATA','POISSON_DATA','WAVEVECTOR_DATA','EIGENVALUE_DATA'}];
    if const.isSaveEigenvectors
        vars_to_save = [vars_to_save,{'EIGENVECTOR_DATA'}];
    end
end
ars.createSafeFold(save_folder)
save(save_file,vars_to_save{:},'-v7.3');

