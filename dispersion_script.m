clear; close all; %delete(findall(0));

isSaveOutput = false;
struct_tag = 'homogeneous';

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
const.a = 1; % [m]
const.N_ele = 4;
const.N_pix = 5;
const.N_k = 20;
const.N_eig = 8;
const.isUseGPU = false;
const.isUseImprovement = true;
const.isUseParallel = false;

const.wavevectors = create_IBZ_boundary_wavevectors(const.N_k,const.a);

%% Random cell
const.design = get_design(struct_tag,const.N_pix);

const.E_min = 2e9;
const.E_max = 200e9;
const.rho_min = 1e3;
const.rho_max = 8e3;
const.poisson_min = 0;
const.poisson_max = .5;
const.t = 1;
const.sigma_eig = 1;

%% Plot the design
fig = plot_design(const.design);
if isSaveOutput
    fix_pdf_border(fig)
    save_in_all_formats(fig,'design',plot_folder,false)
end

%% Solve the dispersion problem
[wv,fr,ev] = dispersion(const,const.wavevectors);
fr(:,end + 1) = fr(:,1);
ev(:,end + 1,:) = ev(:,1,:);
wn = linspace(0,3,size(const.wavevectors,2) + 1);
wn = repmat(wn,const.N_eig,1);

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
plot_mode_ui(wv,fr,ev,const);
% plot_mode(wv,fr,ev,eig_idx,k_idx,'both',const)

