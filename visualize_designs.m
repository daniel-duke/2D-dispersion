clear; close all;

mfn = mfilename;
disp(mfn)

N_struct = 8;
rng_seed_offset = 2;
cmap = 'parula';
isShowTicks = false;
isUsePresetFigurePosition = true;

const.a = 1; % [m]
const.N_pix = 32;

design_params = design_parameters;
design_params.design_number = []; % leave empty
design_params.design_style = 'kernel';
design_params.design_options = struct('kernel','periodic','sigma_f',1,'sigma_l',1,'symmetry_type','none','N_value',3);
design_params.N_pix = [const.N_pix const.N_pix];
design_params = design_params.prepare();

const.E_min = 200e6; % 2e9
const.E_max = 200e9; % 200e9
const.rho_min = 8e2; % 1e3
const.rho_max = 8e3; % 8e3
const.poisson_min = 0; % 0
const.poisson_max = .5; % .5
const.t = 1;
const.sigma_eig = 1;

const.symmetry_type = 'c1m1'; IBZ_shape = 'rectangle'; num_tesselations = 1;

const.design_scale = 'linear';
const.design = nan(const.N_pix,const.N_pix,3); % This is just a temporary value so that 'const' has the field 'design' used in the parfor loop

%% Generate designs
if isUsePresetFigurePosition
    data = load([mfn '_preset_figure_position']);
    preset_figure_position = data.preset_figure_position;
    fig = figure('Position',preset_figure_position);
else
    fig = figure;
end

tlo = tiledlayout('flow');
tlo.TileSpacing = 'compact';
for struct_idx = 1:N_struct
    pfc = const;
    pfdp = design_params;
    
    pfdp.design_number = struct_idx + rng_seed_offset;
    pfdp = pfdp.prepare();
    pfc.design = get_design2(pfdp);
    pfc.design = convert_design(pfc.design,'linear',pfc.design_scale,pfc.E_min,pfc.E_max,pfc.rho_min,pfc.rho_max);

    designs(struct_idx,:,:,:) = pfc.design;
    
    ax = nexttile;
    imagesc(pfc.design(:,:,1))
    colormap(cmap)
    daspect([1 1 1])
    if ~isShowTicks
        set(ax,'XTickLabel',[])
        set(ax,'YTickLabel',[])
        set(ax,'XTick',[])
        set(ax,'YTick',[])
    end

%     colorbar
end

% Export figure
exportgraphics(fig,[mfn '_export.pdf'],'contenttype','vector')

% Save preset_figure_position
% preset_figure_position = fig.Position;
% save([mfn '_preset_figure_position'],"preset_figure_position")

