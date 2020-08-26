function [wn,fr,ev,wv] = dispersion(const)
    
    wavevectors = linspaceNDim([0;0],[pi/const.a; 0],const.N_k);
    wavevectors = [wavevectors(:,1:(end-1)) linspaceNDim([pi/const.a; 0],[pi/const.a; pi/const.a],const.N_k)];
    wavevectors = [wavevectors(:,1:(end-1)) linspaceNDim([pi/const.a; pi/const.a],[0; 0],const.N_k)];
    wavevectors = wavevectors(:,1:(end-1));
    
    fr = zeros(const.N_eig,3*const.N_k - 2);
    ev = zeros(const.N_eig,3*const.N_k - 2,((const.N_ele*const.N_pix)^2)*2);
    [K,M] = get_system_matrices(const);
    parfor k_idx = 1:(3*const.N_k - 3)
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
%             Kr_gpu = gpuArray(Kr); Mr_gpu = gpuArray(Mr);
%             [eig_vecs,eig_vals] = eig(inv(Mr_gpu)*Kr_gpu);
            MinvK_gpu = gpuArray(full(inv(Mr)*Kr));
            [eig_vecs,eig_vals] = eig(MinvK_gpu);
            [eig_vals,idxs] = sort(diag(eig_vals));
            eig_vecs = eig_vecs(:,idxs);
            fr(:,k_idx) = sqrt(real(eig_vals(1:const.N_eig)));
            fr(:,k_idx) = fr(:,k_idx)/(2*pi);
        end
    end
    wn = linspace(0,3,size(wavevectors,2) + 1);
    wn = repmat(wn,const.N_eig,1);
    
    fr(:,end) = fr(:,1);
    ev(:,end) = ev(:,1);
    
    wv = wavevectors;
end
    
    
    