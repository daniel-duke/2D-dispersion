function C = periodic_kernel(points_i,points_j,kernel_params)
    sigma_f = kernel_params.sigma_f;
    length_scale = kernel_params.length_scale;
    period = kernel_params.period;
    points_i = permute(points_i,[1 3 2]);
    points_j = permute(points_j,[1 3 2]);
    displacements = points_i - permute(points_j,[2 1 3]);

    sin_arg1 = pi*abs(displacements(:,:,1)/period);
    C1 = sigma_f^2*exp(-2*sin(sin_arg1).^2/length_scale^2);
    sin_arg2 = pi*abs(displacements(:,:,2)/period);
    C2 = sigma_f^2*exp(-2*sin(sin_arg2).^2/length_scale^2);
    C = C1.*C2;
end