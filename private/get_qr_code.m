function prop = get_qr_code(N_pix,design_options)
    %%% parameters
    min_logF = design_options.min_logF;     % minimum of uniform frequency distribution  
    max_logF = design_options.max_logF;     % maximum of uniform frequency distribution
    N_Fx = design_options.N_Fx;             % number of randomly sampled x frequencies
    N_Fy = design_options.N_Fy;             % number of randomly sampled y frequencies
    fudge = design_options.fudge;           % length scale of fudging
   
    %%% initialize colors
    cx = ones(1,N_pix);
    cy = ones(1,N_pix);
    
    %%% x frequencies
    for f = 1:N_Fx
        w = N_pix/uniform_logF(min_logF,max_logF);
        for i = 1:N_pix
            if mod(round(i/w),2) == 0
                cx(i) = -cx(i);
            end
        end
    end
    
    %%% y frequencies
    for f = 1:N_Fy
        w = N_pix/uniform_logF(min_logF,max_logF);
        for i = 1:N_pix
            if mod(round(i/w),2) == 0
                cy(i) = -cy(i);
            end
        end
    end
    
    %%% combine x and y to get color
    [cx2,cy2] = meshgrid(cx,cy);
    c2 = cx2.*cy2;

    %%% fudging
    c2f = c2;
    fudge = round(fudge*N_pix);
    fudge2 = fudge^2;
    for i = 1:N_pix
        for j = 1:N_pix
            tally = 0;
            count = 0;
            for i2 = max(i-fudge,1):i-1
                for j2 = max(j-fudge,1):j-1
                    if (i-fudge-i2)^2+(j-fudge-j2)^2 > fudge2
                        tally = tally + c2(i2,j2);
                        count = count + 1;
                    end
                end
            end
            for i2 = max(i-fudge,1):i-1
                for j2 = j+1:min(j+fudge,N_pix)
                    if (i-fudge-i2)^2+(j+fudge-j2)^2 > fudge2
                        tally = tally - c2(i2,j2);
                        count = count + 1;
                    end
                end
            end
            for i2 = i+1:min(i+fudge,N_pix)
                for j2 = max(j-fudge,1):j-1
                    if (i+fudge-i2)^2+(j-fudge-j2)^2 > fudge2
                        tally = tally - c2(i2,j2);
                        count = count + 1;
                    end
                end
            end
            for i2 = i+1:min(i+fudge,N_pix)
                for j2 = j+1:min(j+fudge,N_pix)
                    if (i+fudge-i2)^2+(j+fudge-j2)^2 > fudge2
                        tally = tally + c2(i2,j2);
                        count = count + 1;
                    end
                end
            end
            if abs(tally/count) > 0
                switch design_options.fill
                    case 'min'
                        c2f(i,j) = -1;
                    case 'max'
                        c2f(i,j) = 1;
                    otherwise
                        error('unknown material type')
                end
            end
        end
    end

    %%% replace -1 with 0
    prop = max(c2f,0);
end

function F = uniform_logF(min_logF,max_logF)
    logF = min_logF + rand*(max_logF-min_logF);
    F = roundToNearestPowerOf2(10^logF);
end

function nearestPowerOf2 = roundToNearestPowerOf2(num)
    lowerPower = 2^floor(log2(num));
    upperPower = 2^ceil(log2(num));
    if (num - lowerPower) < (upperPower - num)
        nearestPowerOf2 = lowerPower;
    else
        nearestPowerOf2 = upperPower;
    end
end
