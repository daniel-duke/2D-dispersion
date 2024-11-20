function [wv,fr,ev] = dispersion(const,wavevectors)
    
    N_dof = ((const.N_ele*const.N_pix)^2)*2; % Total number of degrees of freedom in the model *after* boundary conditions have been applied
    % if const.N_eig>N_dof
    %     error('Number of requested eigenvalues is larger than the number of degrees of freedom in the finite element model.')
    % end
    
    fr = zeros(size(wavevectors,2),const.N_eig);
    if const.isSaveEigenvectors
        ev = zeros(N_dof,size(wavevectors,2),const.N_eig);
    else
        ev = [];
    end

    if const.isUseSecondImprovement
        [K,M] = get_system_matrices_VEC_simplified(const);
    elseif const.isUseImprovement
        [K,M] = get_system_matrices_VEC(const);
    else
        [K,M] = get_system_matrices(const);
    end

    if const.isUseParallel
        parforArg = Inf;
    else
        parforArg = 0;
    end

    % for k_idx = 1:size(wavevectors,1) %warning('parfor loop is commented out - performance will suffer!') % USE THIS TO DEBUG
    parfor (k_idx = 1:size(wavevectors,1), parforArg) % USE THIS FOR PERFORMANCE
        wavevector = wavevectors(k_idx,:);
        T = get_transformation_matrix(wavevector,const);
        Kr = T'*K*T;
        Mr = T'*M*T;

        % Ensure system matrices are hermitian?
        % assert(ishermitian(Kr))
        % assert(ishermitian(Mr))
                 
        [eig_vecs,eig_vals] = eigs(Kr,Mr,const.N_eig,const.sigma_eig);
        [eig_vals,idxs] = sort(diag(eig_vals));
        eig_vecs = eig_vecs(:,idxs);
        
        if const.isSaveEigenvectors
            ev(:,k_idx,:) = (eig_vecs./vecnorm(eig_vecs,2,1)).*exp(-1i*angle(eig_vecs(1,:))); % normalize by p-norm, align complex angle
        end
%         ev(:,k_idx,:) = (eig_vecs./max(eig_vecs))'; % normalize by max
%         ev(:,k_idx,:) = (eig_vecs./(diag(eig_vecs'*Mr*eig_vecs)'))'; % normalize by mass matrix
%         ev(:,k_idx,:) = eig_vecs'; % don't normalize
        
        fr(k_idx,:) = sqrt(real(eig_vals));
        fr(k_idx,:) = fr(k_idx,:)/(2*pi); % convert angular frequency to hertz
        
    end
    wv = wavevectors;
    
end


