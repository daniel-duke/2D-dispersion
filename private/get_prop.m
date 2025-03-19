function prop = get_prop(design_parameters,prop_idx)

    design_number = design_parameters.design_number(prop_idx);
    design_style = design_parameters.design_style{prop_idx};
    design_options = design_parameters.design_options{prop_idx};
    N_pix = design_parameters.N_pix;

    switch design_style
        case 'homogeneous'
            % Uniform 1
            prop = ones(N_pix);

        case 'constant'
            % Uniform value
            prop = design_options.constant_value*ones(N_pix);

        case 'uncorrelated'
            % Random pixels
            rng(design_number,'twister')
            prop = rand(N_pix);

        case 'kernel'
            % Correlated random pixels
            rng(design_number+design_options.offset,'twister')
            prop = kernel_prop(N_pix,design_options);

        case 'dispersive-tetragonal'
            % 0 0 0 0
            % 0 1 1 0
            % 0 1 1 0
            % 0 0 0 0
            N_pix_inclusion = design_options.feature_size;
            prop = zeros(N_pix);
            mask = zeros(N_pix,1);
            mask(1:N_pix_inclusion) = 1;
            mask = circshift(mask,round((N_pix - N_pix_inclusion)/2));
            idxs = find(mask);
            prop(idxs,idxs) = 1;

        case 'dispersive-tetragonal-negative'
            % 1 1 1 1
            % 1 0 0 1
            % 1 0 0 1
            % 1 1 1 1
            N_pix_inclusion = design_options.feature_size;
            prop = zeros(N_pix);
            mask = zeros(N_pix,1);
            mask(1:N_pix_inclusion) = 1;
            mask = circshift(mask,round((N_pix - N_pix_inclusion)/2));
            idxs = find(mask);
            prop(idxs,idxs) = 1;
            prop = ~prop;

        case 'dispersive-orthotropic'
            % 0 1 1 0
            % 0 1 1 0
            % 0 1 1 0
            % 0 1 1 0
            prop = zeros(N_pix);
            mask = round((N_pix/4 + 1):(3*N_pix/4));
            prop(:,mask) = 1;

        case 'quasi-1D'
            % 1 0 1 0
            % 1 0 1 0
            % 1 0 1 0
            % 1 0 1 0
            prop = ones(N_pix);
            prop(:,1:2:end) = 0;

        case 'diagonal-band'
            % 1 1 0 0
            % 1 1 1 0
            % 0 1 1 1
            % 0 0 1 1
            prop = eye(design_parameters.N_pix);
            for i = 1:design_options.feature_size
                prop = prop + diag(ones(N_pix-i,1),i);
                prop = prop + diag(ones(N_pix-i,1),-i);
            end

        case 'rotationally-symmetric'
            % 0 0 0 0
            % 0 1 0 0
            % 0 0 1 0
            % 0 0 0 0
            prop = zeros(N_pix);
            mask = (N_pix/4 + 1):(2*N_pix/4);
            prop(mask,mask) = 1;
            mask = (2*N_pix/4 + 1):(3*N_pix/4);
            prop(mask,mask) = 1;

        case 'sierpinski'
            % 0 0 0 0 0 0
            % 0 0 1 1 1 0
            % 0 0 0 1 1 0
            % 0 1 1 0 1 0
            % 0 0 1 0 0 0
            % 0 0 0 0 0 0
            if mod(N_pis(1),30) ~= 0
                error("N_pix must be multiple of 30 for sierpinski design")
            end
            
            ratio = N_pix/30;
            prop = ones(N_pix);

            mask = false(size(prop));
            cols = (ratio*2 + 1):(ratio*14);
            rows = (ratio*(30 - 14) + 1):(ratio*(30-2));
            mask(rows,cols) = triu(true(ratio*12));
            prop(mask) = 0;

            mask = false(size(prop));
            cols = (ratio*4 + 1):(ratio*28);
            rows = (ratio*(30 - 28) + 1):(ratio*(30-4));
            mask(rows,cols) = triu(true(ratio*24));
            prop(mask) = 0;

        case 'qr_code'
            % random frequencies directly represented by intersecting horizontal and vertical bars
            rng(design_number+design_options.offset,'twister')
            prop = get_qr_code(N_pix,design_options);

        case 'gaussian'
            % periodic gaussian field with exponential correlation
            rng(design_number+design_options.offset,'twister')
            prop = get_gaussian(N_pix,design_options);

        otherwise
            error(['design not recognized: ' design_style])
    end

    %%% apply symmerty
    if isfield(design_options,'symmetry_type')
        prop_nosym = prop;
        prop = apply_symmetry(prop_nosym,design_options.symmetry_type);

        %%% rotate and flip prop until symmetric version is nonuniform
        attempts = 0;
        while isscalar(unique(prop))
            attempts = attempts + 1;
            if attempts == 5
                prop_nosym = flipud(prop_nosym);
            end
            if attempts == 9
                error("could not apply symmetry without getting uniform prop")
            end
            prop_nosym = rot90(prop_nosym);
            prop = apply_symmetry(prop_nosym,design_options.symmetry_type);
        end
    end

    %%% apply discretization
    if isfield(design_options,'N_value') && design_options.N_value ~= inf
        prop = round((design_options.N_value - 1)*prop)/(design_options.N_value - 1);
    end

end