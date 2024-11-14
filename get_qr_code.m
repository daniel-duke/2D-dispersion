function prop = get_qr_code(N_pix,design_number)
    %%% parameters
    min_logF = 0;          % minimum of uniform frequency distribution  
    max_logF = 1;          % maximum of uniform frequency distribution
    nFx = 4;               % number of randomly sampled x frequencies
    nFy = 4;               % number of randomly sampled y frequencies
    symmetry = 0;          % 0 for no symmetry, 1 for quarter symmetry, 2 for eighth symmetry

    %%% control random number generation
    rng(design_number,'twister')
   
    %%% initialize colors
    if symmetry == 0
        N_pixS = N_pix;
    else
        N_pixS = N_pix./2;
    end
    cx = ones(1,N_pixS(1));
    cy = ones(1,N_pixS(2));
    
    %%% x frequencies
    for f = 1:nFx
        w = N_pixS(1)*uniform_logF(min_logF,max_logF);
        for i = 1:N_pixS(1)
            if mod(round(i/w),2) == 0
                cx(i) = -cx(i);
            end
        end
    end
    
    %%% y frequencies
    for f = 1:nFy
        w = N_pixS(2)*uniform_logF(min_logF,max_logF);
        for i = 1:N_pixS(2)
            if mod(round(i/w),2) == 0
                cy(i) = -cy(i);
            end
        end
    end
    
    %%% combine x and y to get color
    [cx2,cy2] = meshgrid(cx,cy);
    c2 = cx2.*cy2;

    %%% fudging
    fudge = 0;
    threshold = 0;
    c2f = c2;
    for i = 1:N_pixS(1)
        for j = 1:N_pixS(2)
            track = 0;
            count = 0;
            for i2 = max(i-fudge,1):min(i+fudge,N_pixS(1))
                for j2 = max(j-fudge,1):min(j+fudge,N_pixS(2))
                    count = count + 1;
                    track = track + c2(i2,j2);
                end
            end
            if track/count > threshold
                c2f(i,j) = 1;
            else
                c2f(i,j) = -1;
            end
        end
    end
    c2f = max(c2f,0);

    if symmetry == 0
        prop = c2f;
    else
        prop = zeros(N_pix);
        prop( 1:N_pixQ(1),          1:N_pixQ(2)          ) = c2f;
        prop( N_pixQ(1)+1:N_pix(1), 1:N_pixQ(2)          ) = flip(c2f,1);
        prop( 1:N_pixQ(1),          N_pixQ(2)+1:N_pix(2) ) = flip(c2f,2);
        prop( N_pixQ(1)+1:N_pix(1), N_pixQ(2)+1:N_pix(2) ) = flip(flip(c2f,1),2);
    end
end