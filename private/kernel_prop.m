function prop = kernel_prop(N_pix,design_options)
    xx = linspace(0,1,N_pix);
    yy = linspace(0,1,N_pix);
    [X,Y] = meshgrid(xx,yy);
    points = [reshape(X,[],1),reshape(Y,[],1)];
    
    switch design_options.kernel
        case 'matern52'
            C = matern52_kernel(points,points,design_options.sigma_f,design_options.sigma_l);

        case 'periodic'
            period = [1 1];
            C = periodic_kernel(points,points,design_options.sigma_f,design_options.sigma_l,period);

        otherwise
            error(['kernel name "' design_options.kernel '" not recognized'])
    end

    mu = 0.5*ones(1,size(points,1));
    prop = mvnrnd(mu,C);
    prop = reshape(prop,[N_pix N_pix]);
    prop(prop<0) = 0;
    prop(prop>1) = 1;

    %%% if property is uniform, subtract mean before applying limits
    if isscalar(unique(prop))
        prop = mvnrnd(mu,C);
        prop = reshape(prop,[N_pix N_pix]);
        prop = prop - mean(prop,'all') + 0.5;
        prop(prop<0) = 0;
        prop(prop>1) = 1;
    end

end