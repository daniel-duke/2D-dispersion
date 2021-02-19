function [wv,fr,ev,cg] = dispersion2(const,wavevectors)
    
    fr = zeros(size(wavevectors,2),const.N_eig);
    ev = zeros(((const.N_ele*const.N_pix)^2)*2,size(wavevectors,2),const.N_eig);
    if const.isUseImprovement
        [K,M] = get_system_matrices_VEC(const);
    else
        if const.isComputeDesignSensitivity
            [K,M,dKddesign,dMddesign] = get_system_matrices(const);
        else
            [K,M] = get_system_matrices(const);
        end
    end
    if const.isUseParallel
        parforArg = Inf;
    else
        parforArg = 0;
    end
%     for k_idx = 1:size(wavevectors,2) % USE THIS TO DEBUG
    parfor (k_idx = 1:size(wavevectors,1), parforArg)
        wavevector = wavevectors(k_idx,:);
        if const.isComputeGroupVelocity
            [T,dTdwavevector] = get_transformation_matrix(wavevector,const);
        else
            T = get_transformation_matrix(wavevector,const);
        end
        
        Kr = T'*K*T;
        Mr = T'*M*T;
        
        % DONT USE THE GPU WITH EIGS
        [eig_vecs,eig_vals] = eigs(Kr,Mr,const.N_eig,const.sigma_eig);
        [eig_vals,idxs] = sort(diag(eig_vals));
        eig_vecs = eig_vecs(:,idxs);
        
        ev(:,k_idx,:) = (eig_vecs./vecnorm(eig_vecs,2,1)); % normalize by p-norm
        
        fr(k_idx,:) = sqrt(real(eig_vals)); % take square root of eigenvalue
        fr(k_idx,:) = fr(k_idx,:)/(2*pi); % convert angular frequency to hertz
    end
    wv = wavevectors;
end


