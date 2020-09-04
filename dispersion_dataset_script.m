clear; close all;

isSaveOutput = true;
N_struct = 400;

const.a = 1; % [m]
const.N_ele = 8;
const.N_pix = 4;
const.N_k = 100;
const.N_eig = 8;
const.isUseGPU = false;
const.isUseImprovement = true;
const.isUseParallel = false;

const.E_min = 2e9;
const.E_max = 200e9;
const.rho_min = 1e3;
const.rho_max = 8e3;
const.poisson_min = 0;
const.poisson_max = .5;
const.t = 1;
const.sigma_eig = 1;

% const.wavevectors = create_wavevector_array(const.N_k,const.a);
const.wavevectors = linspaceNDim([0;0],[pi/const.a;0],const.N_k);

const.design = ones(const.N_pix,const.N_pix,3);


%% Set up save locations
if ~isSaveOutput
    disp('WARNING: isSaveOutput is set to false. Output will not be saved.')
end
script_start_time = replace(char(datetime),':','-');
if isSaveOutput
    output_folder = ['OUTPUT/output ' script_start_time]; 
    mkdir(output_folder);
    copyfile([mfilename('fullpath') '.m'],[output_folder '/' mfilename '.m']);
end

%% Generate dataset
pfwb = parfor_wait(N_struct,'Waitbar', true);
parfor struct_idx = 1:N_struct
    pfc = const;
    % Random cell
    pfc.design(:,:,1) = round(rand(const.N_pix));
    pfc.design(:,:,2) = const.design(:,:,1);
    pfc.design(:,:,3) = .6*ones(const.N_pix);
    
    % Solve the dispersion problem
    [wv,fr,ev] = dispersion(pfc,pfc.wavevectors);
    WAVEVECTOR_DATA(struct_idx,:,:) = wv;
    EIGENVALUE_DATA(struct_idx,:,:) = fr;
    EIGENVECTOR_DATA(struct_idx,:,:,:) = ev;
    
    % Save the material properties
    ELASTIC_MODULUS_DATA(struct_idx,:,:) = pfc.E_min + (pfc.E_max - pfc.E_min)*pfc.design(:,:,1);
    DENSITY_DATA(struct_idx,:,:) = pfc.rho_min + (pfc.rho_max - pfc.rho_min)*pfc.design(:,:,2);   
    POISSON_DATA(struct_idx,:,:) = pfc.poisson_min + (pfc.poisson_max - pfc.poisson_min)*pfc.design(:,:,3);
    pfwb.Send; %#ok<PFBNS>
end
pfwb.Destroy;

figure2();
hold on
for eig_idx = 1:const.N_eig
    line(squeeze(WAVEVECTOR_DATA(:,1,:))',squeeze(EIGENVALUE_DATA(:,eig_idx,:))','CreateFcn',@(l,e) set(l,'Color',[0 0 0 .1]),'Color',[0 0 0 .1])
end

% struct_idx = 4;
% figure2();
% hold on
% for eig_idx = 1:const.N_eig
% line(squeeze(WAVEVECTOR_DATA(struct_idx,1,:))',squeeze(EIGENVALUE_DATA(struct_idx,eig_idx,:))','CreateFcn',@(l,e) set(l,'Color',[0 0 0 .1]),'Color',[0 0 0 .1])
% end

%% Save the results
if isSaveOutput
    CONSTITUTIVE_DATA = containers.Map({'modulus','density','poisson'},... 
        {ELASTIC_MODULUS_DATA, DENSITY_DATA, POISSON_DATA}); 
    output_file_path = [output_folder '/DATA N_struct' num2str(N_struct) ' ' script_start_time '.mat'];
    save(output_file_path,'WAVEVECTOR_DATA','EIGENVALUE_DATA','EIGENVECTOR_DATA','CONSTITUTIVE_DATA','-v7.3');
%     plot_output_PERF('isSavePlots', true,'output_file_path',output_file_path);
end
