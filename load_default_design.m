function design = load_default_design(design_name,N_pix)
    switch design_name
        case 'dispersive-tetragonal'
            % Dispersive cell - Tetragonal
            design(:,:,1) = zeros(N_pix); % the first pane is E
            idxs = (N_pix/4 + 1):(3*N_pix/4);
            design(idxs,idxs,1) = 1;
            design(:,:,2) = design(:,:,1); % the second pane is rho
            design(:,:,3) = .6*ones(N_pix); % the third pane is poisson's ratio
        case 'dispersive-orthotropic'
            % Dispersive cell - Orthotropic
            design(:,:,1) = zeros(N_pix); % the first pane is E
            idxs = (N_pix/4 + 1):(3*N_pix/4);
            design(:,idxs,1) = 1;
            design(:,:,2) = design(:,:,1); % the second pane is rho
            design(:,:,3) = .6*ones(N_pix); % the third pane is poisson's ratio
        case 'homogeneous'
            % Homogeneous cell
            design(:,:,1) = ones(N_pix); % the first pane is E
            design(:,:,2) = design(:,:,1); % the second pane is rho
            design(:,:,3) = .6*ones(N_pix); % the third pane is poisson's ratio
        case 'quasi-1D'
            % Quasi-1D cell
            design(:,:,1) = ones(N_pix);
            design(:,1:2:end,1) = 0;
            design(:,:,2) = design(:,:,1);
            design(:,:,3) = .6*ones(N_pix);
        case 'rotationally-symmetric'
            design(:,:,1) = zeros(N_pix);
            idxs = (N_pix/4 + 1):(2*N_pix/4);
            design(idxs,idxs,1) = 1;
            idxs = (2*N_pix/4 + 1):(3*N_pix/4);
            design(idxs,idxs,1) = 1;
            design(:,:,2) = design(:,:,1); % the second pane is rho
            design(:,:,3) = .6*ones(N_pix); % the third pane is poisson's ratio
        otherwise
            error(['design not recognized: ' design_name])
    end
end