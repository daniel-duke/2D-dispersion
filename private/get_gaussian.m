function prop = get_gaussian(N_pix,design_options)
    %%% parameters
    lambda = design_options.lambda;                     % correlation length
    threshold_lower = design_options.thresholds(1);     % 0 for even, 1 for more fill, -1 for less fill
    threshold_upper = design_options.thresholds(2);     % 0 for even, 1 for more fill, -1 for less fill

    %%% control random number generation

    %%% check N_pix
    if mod(N_pix,2) ~= 0
        error("for now, N_pix must be even for gaussian field")
    end
    
    %%% define the distance grid
    kx = lambda*[0:(N_pix/2), -(N_pix/2-1):-1];
    ky = lambda*[0:(N_pix/2), -(N_pix/2-1):-1];
    [KX, KY] = meshgrid(kx, ky);
    R2 = KX.^2 + KY.^2;
    
    %%% define the covariance
    C = exp(-R2./2);
    
    %%% generate Gaussian random variables in Fourier space
    Z_real = randn(N_pix);
    Z_imag = randn(N_pix);
    Z = Z_real + 1i * Z_imag;
    
    %%% scale by the covariance
    field_hat = Z .* C;
    
    %%% inverse FFT to get the Gaussian random field
    field = real(ifft2(field_hat));

    %%% normalize and threshold
    field = field - mean(field,'all');
    field = field./std(field,0,'all');
    if threshold_upper == threshold_lower
        field(field>threshold_upper) = threshold_upper+1;
        field(field<threshold_lower) = threshold_lower-1;
        field = (field+1)/2;
    else
        field(field>threshold_upper) = threshold_upper;
        field(field<threshold_lower) = threshold_lower;
        field = (field-threshold_lower)/(threshold_upper-threshold_lower);
    end
    prop = field;

end