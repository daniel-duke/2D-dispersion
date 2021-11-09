clear all; %close all; 
%delete(findall(0));

isSaveOutput = false;
data = load('G:\My Drive\Research\Duke\Codes\2D data\multiplexer\multiplexer_20x20_new.mat');
%load('G:\My Drive\Research\Duke\Codes\2D codes\2D-dispersion_ComplexWN\Designs.mat');
%all_designs = Designs;
%all_designs = data.pass_3; 
all_designs = data.block_all;
struct_tag = '1';




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
const.a = 1; % unit-cell side length [m]
const.Nod_dof = 1; % no. of degrees of freedom per node, e.g., ux, uy, uz 
                   % 2 if PSV waves, 1 if SH waves, 3 if both (to be implemented later)
const.N_ele = 4; % no. of elements per pixel
const.N_eig = 10; % no. of computed eigenvalues
const.isUseGPU = false;
const.isUseImprovement = 1; % use vectorized improvement
const.isUseParallel = true;
const.complex_wn = 0;


const.E_min = 2e9;
const.E_max = 200e9;
const.rho_min = 2.7e3;
const.rho_max = 8e3;
const.poisson_min = 0;
const.poisson_max = .5;

% const.E_min = 0;
% const.E_max = 200e9;
% const.rho_min = 0;
% const.rho_max = 8e3;
% const.poisson_min = 0;
% const.poisson_max = .5;
const.t = 1;
const.sigma_eig = 1;

%% Random cell
const.design_scale = 'linear';
dco = 1;

% % In case of using my structures 
% const.design(:,:,1) = VecToDesign(Designs(dco).ReducedDesign, ...
%     const.N_pix);
% const.design(:,:,2) = VecToDesign(Designs(dco).ReducedDesign, ...
%     const.N_pix);
% const.design(:,:,3) = ones(const.N_pix).*0.6;


% In case of using the structures from Alex
%const.design = get_design(struct_tag,const.N_pix);
const.design = all_designs(:,:,:,dco);
const.N_pix = size(const.design,1); % no. of pixels per side length




% Plot the design
fig = plot_design(const.design);
if isSaveOutput
    fix_pdf_border(fig)
    save_in_all_formats(fig,'design',plot_folder,false)
end

% % Check if design is valid (with void option)
% 
% if const.isUseImprovement
%     [K,M] = get_system_matrices_VEC(const);
% else
%     [K,M] = get_system_matrices(const);
% end
% tic 
% test_eigs = eigs(K,6,'smallestabs'); 
% toc


%% Solve the dispersion problem
tic 
if const.complex_wn
    const.fr = 0.001:1:2501;
    [wv_MG,wv_GX,wv_XM,fr] = dispersion_complexwn(const,const.fr);
else
    const.N_k = 21; % no. of wave vector sampling points along one side of IBZ
    const.wavevectors = create_IBZ_boundary_wavevectors(const.N_k,const.a);
    [wv,fr,ev] = dispersion(const,const.wavevectors);
    fr(end+1,:) = fr(1,:);
    ev(:,end + 1,:) = ev(:,1,:);
    wn = linspace(0,3,size(const.wavevectors,1) + 1)';
    wn = repmat(wn,1,const.N_eig);
end
toc
%%
if ~const.complex_wn
    
    % Plot the discretized Irreducible Brillouin Zone
    fig = plot_wavevectors(wv,const.a,const.N_k);
    if isSaveOutput
        fig = fix_pdf_border(fig);
        save_in_all_formats(fig,'wavevectors',plot_folder,false)
    end
end

%% Plot the dispersion relation
if const.complex_wn
    
    % 3D plot
    % fig1 = plot_3Dcomplexdispersion(wv_MG,wv_GX,wv_XM,fr,const.a);
    
    % 2D plot
    fig2 = plot_2Dcomplexdispersion(wv_MG,wv_GX,wv_XM,fr,const.a);
    fig3 = plot_2Dcomplexdispersion_all(wv_MG,wv_GX,wv_XM,fr,const.a);

    
    if isSaveOutput
        fig1 = fix_pdf_border(fig1);
        save_in_all_formats(fig1,'complex_dispersion_3D',plot_folder,false)
        fig2 = fix_pdf_border(fig2);
        save_in_all_formats(fig2,'complex_dispersion_3D',plot_folder,false)
    end
    
else
    fig = plot_dispersion(wn,fr,const.N_k);
    if isSaveOutput
        fig = fix_pdf_border(fig);
        save_in_all_formats(fig,'dispersion',plot_folder,false)
    end
end









%%
% Plot the modes
k_idx = 2;
eig_idx = 5;
wavevector = wv(:,k_idx);
plot_mode_ui(wv,fr,ev,const);
plot_mode(wv,fr,ev,eig_idx,k_idx,'still',1,const)

