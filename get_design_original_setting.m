function [const] = get_design_original_setting(design, const)

    const.E_min = 2e6;
    const.E_max = 2e9;
    const.rho_min = 1150;
    const.rho_max = 1170;
    const.poisson_min = 0.29;
    const.poisson_max = 0.33;
    
    const.design = zeros([size(design) 3]);
    const.design(:,:,1) = design; % the first pane is E
    const.design(:,:,2) = design; % the second pane is rho
    const.design(:,:,3) = 1-design; % the third pane is poisson's ratio