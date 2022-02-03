function dispersion_computation = dispersion3(dispersion_computation)
    
    dcp = dispersion_computation.dispersion_computation_parameters;
    assert(all(dcp.N_pix == size(dispersion_computation.design_variable.E)))
    
    wavevectors = dispersion_computation.wavevector;
    
    fr = zeros(size(wavevectors,2),dcp.N_eig);
    if dcp.isSaveEigenvectors
        ev = zeros(((dcp.N_ele*dcp.N_pix)^2)*2,size(wavevectors,2),dcp.N_eig);
    else
        ev = [];
    end
    if dcp.isUseImprovement
        [K,M] = get_system_matrices_VEC(dispersion_computation);
    else
        [K,M] = get_system_matrices(dispersion_computation);
    end
    if dcp.isUseParallel
        parforArg = Inf;
    else
        parforArg = 0;
    end
    for k_idx = 1:size(wavevectors,1) % USE THIS TO DEBUG
%     parfor (k_idx = 1:size(wavevectors,1), parforArg)
        wavevector = wavevectors(k_idx,:);
        T = get_transformation_matrix(wavevector,dispersion_computation);
        Kr = T'*K*T;
        Mr = T'*M*T;
        
        if ~dcp.isUseGPU
            % DONT USE THE GPU WITH EIGS           
            [eig_vecs,eig_vals] = eigs(Kr,Mr,dcp.N_eig,dcp.sigma_eig);
            [eig_vals,idxs] = sort(diag(eig_vals));
            eig_vecs = eig_vecs(:,idxs);
            
%             ev(:,k_idx,:) = (eig_vecs./(diag(eig_vecs'*Mr*eig_vecs)'))'; % normalize by mass matrix
            if dcp.isSaveEigenvectors
                ev(:,k_idx,:) = (eig_vecs./vecnorm(eig_vecs,2,1)).*exp(-1i*angle(eig_vecs(1,:))); % normalize by p-norm, align complex angle
            end
            %             ev(:,k_idx,:) = (eig_vecs./max(eig_vecs))'; % normalize by max
%             ev(:,k_idx,:) = eig_vecs'; % don't normalize
            
            fr(k_idx,:) = sqrt(real(eig_vals));
            fr(k_idx,:) = fr(k_idx,:)/(2*pi);
        elseif dcp.isUseGPU
            % USE THE GPU WITH EIG
            error('GPU use is not currently developed');
            MinvK_gpu = gpuArray(full(inv(Mr)*Kr));
            [eig_vecs,eig_vals] = eig(MinvK_gpu);
            [eig_vals,idxs] = sort(diag(eig_vals));
            eig_vecs = eig_vecs(:,idxs);
            fr(k_idx,:) = sqrt(real(eig_vals(1:const.N_eig)));
            fr(k_idx,:) = fr(k_idx,:)/(2*pi);
        end
    end
    wv = wavevectors;
    
    dispersion_computation.frequency = fr;
    dispersion_computation.wavevector = wv;
    dispersion_computation.eigenvector = ev;
end


