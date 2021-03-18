clear; close all; %delete(findall(0));

isSaveOutput = false;
isPlotDesign = false;
struct_tag = '2';
eig_idxs_to_plot = [1];

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
const.N_ele = 2;
const.N_pix = 3;
const.N_k = 11;
const.N_eig = 8;
const.isUseGPU = false;
const.isUseImprovement = false; % group velocity not supported by get_system_matrices_VEC()
const.isUseParallel = true;
const.isComputeGroupVelocity = true;
const.isComputeFrequencyDesignSensitivity = true;
const.isComputeGroupVelocityDesignSensitivity = true;

symmetry_type = 'none'; IBZ_shape = 'rectangle';
num_tesselations = 1;
const.wavevectors = create_IBZ_wavevectors(const.N_k,const.a,symmetry_type,num_tesselations);
% const.wavevectors = [pi/4 pi/4; pi/4 pi/4+1e-8; pi/4+1e-8 pi/4];

const.design = get_design(struct_tag,const.N_pix);

% const.E_min = 2e9;
% const.E_max = 200e9;
% const.rho_min = 1e3;
% const.rho_max = 8e3;
const.E_min = 100;
const.E_max = 1000;
const.rho_min = 1;
const.rho_max = 10;
const.poisson_min = 0;
const.poisson_max = .5;
const.t = 1;
const.sigma_eig = 1;

%% Plot the design
if isPlotDesign
    fig = plot_design(const.design);
    if isSaveOutput
        fix_pdf_border(fig)
        save_in_all_formats(fig,'design',plot_folder,false)
    end
end

%% Solve the dispersion problem
[wv,fr,ev,cg] = dispersion2(const,const.wavevectors);
fr = real(fr);
% wn = linspace(0,3,size(const.wavevectors,2) + 1);
% wn = repmat(wn,const.N_eig,1);

%% Plot the discretized Irreducible Brillouin Zone
% fig = plot_wavevectors(wv);
% if isSaveOutput
%     fix_pdf_border(fig)
%     save_in_all_formats(fig,'wavevectors',plot_folder,false)
% end

%% Plot the dispersion relation
% fig = figure2();
% ax = axes(fig);
% hold(ax,'on');
% view(ax,3);
for eig_idx_to_plot = eig_idxs_to_plot
    plot_dispersion_surface(wv,fr(:,eig_idx_to_plot),cg(:,:,eig_idx_to_plot));
end
% title(ax,'dispersion relation')
if isSaveOutput
    fix_pdf_border(fig)
    save_in_all_formats(fig,'dispersion',plot_folder,false)
end

% %% Plot the group velocity (x-component)
% fig = figure2();
% ax = axes(fig);
% hold(ax,'on');
% view(ax,3);
% for eig_idx_to_plot = eig_idxs_to_plot
%     plot_dispersion_surface(wv,cg(:,eig_idx_to_plot,1),IBZ_shape,const.N_k,const.N_k,ax);
% end
% title(ax,'group velocity x-component')
% if isSaveOutput
%     fix_pdf_border(fig)
%     save_in_all_formats(fig,'dispersion',plot_folder,false)
% end
% 
% %% Plot the group velocity (y-component)
% fig = figure2();
% ax = axes(fig);
% hold(ax,'on');
% view(ax,3);
% for eig_idx_to_plot = eig_idxs_to_plot
%     plot_dispersion_surface(wv,cg(:,eig_idx_to_plot,2),IBZ_shape,const.N_k,const.N_k,ax);
% end
% title(ax,'group velocity y-component')
% if isSaveOutput
%     fix_pdf_border(fig)
%     save_in_all_formats(fig,'dispersion',plot_folder,false)
% end

%% Plot the modes
% plot_mode_ui(wv,fr,ev,const);

