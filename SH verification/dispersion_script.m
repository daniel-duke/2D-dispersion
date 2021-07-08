clear; close all; 
%delete(findall(0));

isSaveOutput = false;
% zhi_design_idx = 1;
data = load("C:\Users\Mary\Google Drive\Research\Duke\Codes\2D data\sampled_designs_20x20\sampled_20x20_designs_0_1000_minbg_100.mat");
all_designs = data.designs;
% struct_tag = '1';
 struct_tag = 'rotationally-symmetric';


%% Save output setup ... 
script_start_time = replace(char(datetime),':','-');
output_folder = ['OUTPUT/output ' script_start_time];
if isSaveOutput
    mkdir(output_folder);
    copyfile([mfilename('fullpath') '.m'],[output_folder '/' mfilename '.m']);
    plot_folder = create_new_folder('plots',output_folder);
    create_new_folder('pdf',plot_folder)
    create_new_folder('fig',plot_folder)
    create_new_folder('svg',plot_folder)
    create_new_folder('eps',plot_folder)
end

%%
const.a = 0.02; % unit-cell side length [m]
const.Nod_dof = 1; % no. of degrees of freedom per node, e.g., ux, uy, uz 
                   % 2 if PSV waves, 1 if SH waves, 3 if both (to be implemented later)
const.N_ele = 4; % no. of elements per pixel
const.N_pix = 4; % no. of pixels per side length
const.N_k = 11; % no. of wave vector sampling points along one side of IBZ
const.N_eig = 10; % no. of computed eigenvalues
const.isUseGPU = false;
const.isUseImprovement = 0; % use vectorized improvement
const.isUseParallel = true;

const.wavevectors = create_IBZ_boundary_wavevectors(const.N_k,const.a);

const.E_min = 4E9;
const.E_max = 20e9;
const.rho_min = 1e3;
const.rho_max = 2e3;
const.poisson_min = 0.34;
const.poisson_max = 0.34;
const.t = 1;
const.sigma_eig = 1;

% const.E_min = 2e9;
% const.E_max = 200e9;
% const.rho_min = 1e3;
% const.rho_max = 8e3;
% const.poisson_min = 0;
% const.poisson_max = .5;
% const.t = 1;
% const.sigma_eig = 1;

%% Random cell
const.design_scale = 'linear';
zhi_design_idx = 1; 
const.design = get_design(struct_tag,const.N_pix);
% const.design = all_designs(:,:,:,zhi_design_idx);
% const.design = convert_design(const.design,'linear',const.design_scale,const.E_min,const.E_max,const.rho_min,const.rho_max);

%% Plot the design
fig = plot_design(const.design);
if isSaveOutput
    fix_pdf_border(fig)
    save_in_all_formats(fig,'design',plot_folder,false)
end

%% Solve the dispersion problem
[wv,fr,ev] = dispersion(const,const.wavevectors);
fr(end+1,:) = fr(1,:);
ev(:,end + 1,:) = ev(:,1,:);
wn = linspace(0,3,size(const.wavevectors,1) + 1)';
wn = repmat(wn,1,const.N_eig);

%% Plot the discretized Irreducible Brillouin Zone
fig = plot_wavevectors(wv);
if isSaveOutput
    fig = fix_pdf_border(fig);
    save_in_all_formats(fig,'wavevectors',plot_folder,false)
end

%% Plot the dispersion relation
fig = plot_dispersion(wn,fr);
if isSaveOutput
    fig = fix_pdf_border(fig);
    save_in_all_formats(fig,'dispersion',plot_folder,false)
end

%% Plot the modes
% k_idx = 2;
% eig_idx = 5;
% wavevector = wv(:,k_idx);
% plot_mode_ui(wv,fr,ev,const);
% plot_mode(wv,fr,ev,eig_idx,k_idx,'both',const)

