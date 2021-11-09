clear; clc; close all;
isSaveOutput = false;
isPltResults = true;

% load('G:\My Drive\Research\Duke\Codes\2D codes\Designs\DualPhaseDesigns\Designs.mat');
% connected_designs_Ind = load('G:\My Drive\Research\Duke\Codes\2D codes\Designs\Void designs\ConnectedDesignsIndex.mat');
load('Designs.mat');
connected_designs_Ind = load('ConnectedDesignsIndex.mat');

connected_designs_Ind = connected_designs_Ind.ConnectedDesignsIndex;
connected_designs = Designs(connected_designs_Ind);


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

%% Setting problem and design parameters 
% for ico = 1:3%length(connected_designs_Ind)
ico = 1;
dco = connected_designs_Ind(ico);
const.a = 1; % unit-cell side length [m]
const.Nod_dof = 2; % no. of degrees of freedom per node, e.g., ux, uy, uz
% 2 if PSV waves, 1 if SH waves, 3 if both (to be implemented later)
const.N_ele = 4; % no. of elements per pixel
const.N_pix = 10; % no. of pixels per side length
const.N_k = 11; % no. of wave vector sampling points along one side of IBZ
const.N_eig = 30; % no. of computed eigenvalues
const.void = 1; % set to 1 for material + void designs

const.isUseGPU = false;
const.isUseImprovement = 1; % use vectorized improvement
const.isUseParallel = true;

const.wavevectors = create_IBZ_boundary_wavevectors(const.N_k,...
    const.a);

const.E_min = 2e9;
const.E_max = 200e9;
const.rho_min = 1e3;
const.rho_max = 8e3;
const.poisson_min = 0;
const.poisson_max = .5;



if const.void
    const.E_min = 0;
    const.E_max = 2e9;
    const.rho_min = 0;
    const.rho_max = 1e3;
    const.poisson_min = 0;
    const.poisson_max = .5;
end
const.t = 1;
const.sigma_eig = 1;

%% Get full design
const.design_scale = 'linear';
% const.design = get_design(struct_tag,const.N_pix);
const.design(:,:,1) = VecToDesign(Designs(dco).ReducedDesign, ...
    const.N_pix);
const.design(:,:,2) = VecToDesign(Designs(dco).ReducedDesign, ...
    const.N_pix);
const.design(:,:,3) = ones(const.N_pix).*0.6;


%% Plot the design
if isPltResults
    fig = plot_design(const.design);
    if isSaveOutput
        fix_pdf_border(fig)
        save_in_all_formats(fig,'design',plot_folder,false)
    end
end

%% Solve the dispersion problem

[wv,fr,ev] = dispersion(const,const.wavevectors);
fr(end+1,:) = fr(1,:);
ev(:,end + 1,:) = ev(:,1,:);
FREQUENCY_DATA(:,:,ico) = fr;
wn = linspace(0,3,size(const.wavevectors,1) + 1)';
WAVEVECTOR_DATA(:,:,ico) = const.wavevectors;
%EIGENVECTOR_DATA(:,:,:,dco) = ev;


%% Plot the discretized Irreducible Brillouin Zone
if isPltResults
    fig = plot_wavevectors(wv,const.a,const.N_k);
    if isSaveOutput
        fig = fix_pdf_border(fig);
        save_in_all_formats(fig,'wavevectors',plot_folder,false)
    end
end

%% Plot the dispersion relation
if isPltResults
    fig = plot_dispersion(wn,fr,const.N_k);
    if isSaveOutput
        fig = fix_pdf_border(fig);
        save_in_all_formats(fig,'dispersion',plot_folder,false)
    end
end

