function prop = get_gaussian(N_pix,design_number,design_options)
    %%% parameters
    lambda = design_options.lambda;                     % correlation length (in pixels)
    threshold_lower = design_options.thresholds(1);     % 0 for even, 1 for more fill, -1 for less fill
    threshold_upper = design_options.thresholds(2);     % 0 for even, 1 for more fill, -1 for less fill
    symmetry = design_options.symmetry;                 % 0 for no symmetry, 1 for quarter symmetry

    %%% control random number generation
    rng(design_number,'twister')

    %%% pixel adjustment
    if symmetry == 0
        N_pixS = N_pix;
    else
        N_pixS = N_pix./2;
    end
    
    % Step 1: Define the distance grid
    kx = lambda*[0:(N_pixS(1)/2), -(N_pixS(1)/2-1):-1]./N_pixS(1);
    ky = lambda*[0:(N_pixS(2)/2), -(N_pixS(2)/2-1):-1]./N_pixS(2);
    [KX, KY] = meshgrid(kx, ky);
    R2 = KX.^2 + KY.^2;
    
    % Step 2: Define the covariance
    C = exp(-R2./2);
    
    % Step 4: Generate Gaussian random variables in Fourier space
    Z_real = randn(N_pixS(1), N_pixS(2));
    Z_imag = randn(N_pixS(1), N_pixS(2));
    Z = Z_real + 1i * Z_imag;
    
    % Step 5: Scale by the covariance
    field_hat = Z .* C;
    
    % Step 6: Inverse FFT to get the Gaussian random field
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

    %%% assign property values
    if symmetry == 0
        prop = field;
    else
        if symmetry == 2
            for i = 1:N_pixS(1)
                for j = i:N_pixS(1)
                    field(i,j) = field(j,i);
                end
            end
        end
        prop = zeros(N_pix);
        prop( 1:N_pixS(1),          1:N_pixS(2)          ) = field;
        prop( N_pixS(1)+1:N_pix(1), 1:N_pixS(2)          ) = flip(field,1);
        prop( 1:N_pixS(1),          N_pixS(2)+1:N_pix(2) ) = flip(field,2);
        prop( N_pixS(1)+1:N_pix(1), N_pixS(2)+1:N_pix(2) ) = flip(flip(field,1),2);
    end
end