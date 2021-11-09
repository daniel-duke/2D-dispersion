clear;% close all;
%delete(findall(0));
diary 
isSaveOutput = false;
isPltResults = true;

load('C:\Users\Mary\Google Drive\Research\Duke\Codes\2D codes\Designs\Designs.mat');
%load('Designs.mat')


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
for dco = 513:513%1:length(Designs)
    const.a = 1; % unit-cell side length [m]
    const.Nod_dof = 1; % no. of degrees of freedom per node, e.g., ux, uy, uz
    % 2 if PSV waves, 1 if SH waves, 3 if both (to be implemented later)
    const.N_ele = 4; % no. of elements per pixel
    const.N_pix = 10; % no. of pixels per side length
    const.N_k = 11; % no. of wave vector sampling points along one side of IBZ
    const.N_eig = 30; % no. of computed eigenvalues
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
    const.t = 1;
    const.sigma_eig = 1;
    
    %% Random cell
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
    
    % check if this design is translationally symmetric to an existing one
    if dco > 1 
        [Ind, val] = find(extractfield(Designs(1:dco-1), 'trueIndex')...
            == Designs(dco).trueIndex);
    end
    if dco == 1 || isempty(val) 
        [wv,fr,ev] = dispersion(const,const.wavevectors);
        fr(end+1,:) = fr(1,:);
        ev(:,end + 1,:) = ev(:,1,:);
        FREQUENCY_DATA(:,:,dco) = fr;
        %all_designs(dco).fr = fr;
        wn = linspace(0,3,size(const.wavevectors,1) + 1)';
        WAVEVECTOR_DATA(:,:,dco) = repmat(wn,1,const.N_eig);
    else
        FREQUENCY_DATA(:,:,dco) = FREQUENCY_DATA(:,:,val);
        %all_designs(dco).fr = all_designs(val).fr;
        WAVEVECTOR_DATA(:,:,dco) = WAVEVECTOR_DATA(:,:,val);
    end
    
        
    
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
    
end

save('all_designs.mat', 'FREQUENCY_DATA','WAVEVECTOR_DATA','Designs' , '-v7')
%save('all_designs.mat', 'FREQUENCY_DATA','WAVEVECTOR_DATA' , '-v7')

diary("off")
