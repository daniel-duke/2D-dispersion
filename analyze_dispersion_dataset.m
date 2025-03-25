% Housekeeping
clc; clear; close all;

% Load dispersion dataset
dispersion_tag = 'control_sigF20_sigLCombo';
load_folder = 'datasets/production/dispersion/';
load_file = [load_folder dispersion_tag '.mat'];
load(load_file)

% Storage Location
complete_tag = [dispersion_tag '_sr90'];
save_folder = 'datasets/production/complete/';
isSaveOutput = true;

% Trimming parameters
ideal_success_rate = 0;

% Plotting parameters
min_bandgap_width = 50;

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
    save(save_file,vars_to_save{:},'-v7.3');
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
    failure_perm = randperm(N_design-N_bandgap);
    failure_count = 0;
    trimmed_count = 0;
    for i = 1:N_design
        if sum(bandgap_widths(:,i)) > 0
            trimmed_count = trimmed_count + 1;
            idxs_trimmed(trimmed_count) = i;
        else
            failure_count = failure_count + 1;
            if failure_perm(failure_count) <= N_design_trimmed-N_bandgap
                trimmed_count = trimmed_count + 1;
                idxs_trimmed(trimmed_count) = i;
            end
        end
    end
end

