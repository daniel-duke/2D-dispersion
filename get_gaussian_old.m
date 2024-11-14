function prop = get_gaussian_old(N_pix,design_number)
    %%% parameters
    maxF = 4;              % higher value = more bumpy landscape
    threshold = 0;          % 0 for even, 1 for less fill, -1 for more fill
    symmetry = 0;           % 0 for no symmetry, 1 for quarter symmetry
    
    %%% control random number generation
    rng(design_number,'twister')

    %%% pixel adjustment
    N_pix = [N_pix,N_pix];
    if symmetry == 0
        N_pixS = N_pix;
    else
        N_pixS = N_pix./2;
    end
    
    %%% create wave number grid
    kx = (2 * pi)/maxF * [0:(N_pixS(1)/2), -(N_pixS(1)/2-1):-1];
    ky = (2 * pi)/maxF * [0:(N_pixS(2)/2), -(N_pixS(2)/2-1):-1];
    [KX, KY] = meshgrid(kx,ky);
    K2 = KX.^2 + KY.^2;
    
    %%% generate the random Gaussian field in Fourier space
    random_phase = (randn(N_pixS(1), N_pixS(2)) + 1i*randn(N_pixS(1), N_pixS(2))) / sqrt(2);
    amplitude_spectrum = exp(-K2 / 2);
    fourier_field = amplitude_spectrum .* random_phase;
    
    %%% inverse Fourier transform to get the field in spatial domain
    field = real(ifft2(fourier_field));
    field = field - mean(field,'all');
    field = field./mean(field(field>0));

    %%% apply threshold
    field(field>threshold) = threshold+1;
    field(field<threshold) = threshold-1;
    field = (field+1)/2;
    
    %%% assign property values
    if symmetry == 0
        prop = field;
    else
        prop = zeros(N_pix);
        prop( 1:N_pixQ(1),          1:N_pixQ(2)          ) = field;
        prop( N_pixQ(1)+1:N_pix(1), 1:N_pixQ(2)          ) = flip(field,1);
        prop( 1:N_pixQ(1),          N_pixQ(2)+1:N_pix(2) ) = flip(field,2);
        prop( N_pixQ(1)+1:N_pix(1), N_pixQ(2)+1:N_pix(2) ) = flip(flip(field,1),2);
    end
    
end