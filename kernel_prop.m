function prop = kernel_prop(kernel,N_pix,kernel_params)
    xx = linspace(0,1,N_pix(1)); yy = linspace(0,1,N_pix(2));
    [X,Y] = meshgrid(xx,yy);
    points = [reshape(X,[],1),reshape(Y,[],1)];
    %     scatter(points(:,1),points(:,2))

    switch kernel
        case 'matern52'
            C = matern52(points,points,kernel_params);
        case 'periodic'
            C = periodic_kernel(points,points,kernel_params);
        otherwise
            error(['kernel name "' kernel '" not recognized'])
    end
    mu = 0.5*ones(1,size(points,1));
    prop = mvnrnd(mu,C);
    prop = reshape(prop,N_pix);
    prop(prop<0) = 0;
    prop(prop>1) = 1;
end