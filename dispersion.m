function [wv,fr,ev] = dispersion(const,wavevectors)
    
    fr = zeros(const.N_eig,size(wavevectors,2));
    ev = zeros(const.N_eig,size(wavevectors,2),((const.N_ele*const.N_pix)^2)*2);
    [K,M] = get_system_matrices(const);
    if const.isUseParallel
        parforArg = Inf;
    else
        parforArg = 0;
    end
    parfor (k_idx = 1:size(wavevectors,2), parforArg)
        wavevector = wavevectors(:,k_idx);
        T = get_transformation_matrix(wavevector,const);
        Kr = T'*K*T;
        Mr = T'*M*T;
        
        if ~const.isUseGPU
            % DONT USE THE GPU WITH EIGS
            [eig_vecs,eig_vals] = eigs(Kr,Mr,const.N_eig,const.sigma_eig);
            [eig_vals,idxs] = sort(diag(eig_vals));
            eig_vecs = eig_vecs(:,idxs);
            ev(:,k_idx,:) = eig_vecs';
            fr(:,k_idx) = sqrt(real(eig_vals));
            fr(:,k_idx) = fr(:,k_idx)/(2*pi);
        elseif const.isUseGPU
            % USE THE GPU WITH EIG
            error('GPU use is not currently developed');
            MinvK_gpu = gpuArray(full(inv(Mr)*Kr));
            [eig_vecs,eig_vals] = eig(MinvK_gpu);
            [eig_vals,idxs] = sort(diag(eig_vals));
            eig_vecs = eig_vecs(:,idxs);
            fr(:,k_idx) = sqrt(real(eig_vals(1:const.N_eig)));
            fr(:,k_idx) = fr(:,k_idx)/(2*pi);
        end
    end
    wv = wavevectors;
end

