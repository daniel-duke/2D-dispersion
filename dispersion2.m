function [wv,fr,ev,cg,dfrddesign] = dispersion2(const,wavevectors)
    
    fr = zeros(size(wavevectors,1),const.N_eig);
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
    for k_idx = 1:size(wavevectors,1) % USE THIS TO DEBUG
%     parfor (k_idx = 1:size(wavevectors,1), parforArg)
        wavevector = wavevectors(k_idx,:);
        if const.isComputeGroupVelocity
            [T,dTdwavevector] = get_transformation_matrix(wavevector,const);
%             T_prime1 = get_transformation_matrix(wavevector + [1e-8 0],const);
%             dTdwavevector(:,:,1) = (T_prime1-T)/1e-8;
%             T_prime2 = get_transformation_matrix(wavevector + [0 1e-8],const);
%             dTdwavevector(:,:,2) = (T_prime2-T)/1e-8;
        else
            T = get_transformation_matrix(wavevector,const);
        end
        
        Kr = T'*K*T;
        Mr = T'*M*T;
        
        if const.isComputeGroupVelocity
            dKrdwavevector = ndSparse.build([size(Kr) 2]);
            dMrdwavevector = ndSparse.build([size(Mr) 2]);
            for wv_comp_idx = 1:2
                dKrdwavevector(:,:,wv_comp_idx) = dTdwavevector(:,:,wv_comp_idx)'*K*T + T'*K*dTdwavevector(:,:,wv_comp_idx);
                dMrdwavevector(:,:,wv_comp_idx) = dTdwavevector(:,:,wv_comp_idx)'*M*T + T'*M*dTdwavevector(:,:,wv_comp_idx);
            end
%             Kr_prime1 = T_prime1'*K*T_prime1;
%             Kr_prime2 = T_prime2'*K*T_prime2;
%             dKrdwavevector(:,:,1) = (Kr_prime1 - Kr)/1e-8;
%             dKrdwavevector(:,:,2) = (Kr_prime2 - Kr)/1e-8;
%             
%             Mr_prime1 = T_prime1'*M*T_prime1;
%             Mr_prime2 = T_prime2'*M*T_prime2;
%             dMrdwavevector(:,:,1) = (Mr_prime1 - Mr)/1e-8;
%             dMrdwavevector(:,:,2) = (Mr_prime2 - Mr)/1e-8;
        end
        
        % DONT USE THE GPU WITH EIGS
        [eig_vecs,eig_vals] = eigs(Kr,Mr,const.N_eig,const.sigma_eig);
        [eig_vals,idxs] = sort(diag(eig_vals));
        eig_vecs = eig_vecs(:,idxs);
        
%         ev(:,k_idx,:) = (eig_vecs./vecnorm(eig_vecs,2,1)); % normalize by p-norm
        
        fr(k_idx,:) = sqrt(real(eig_vals)); % take square root of eigenvalue
%         fr(k_idx,:) = fr(k_idx,:)/(2*pi); % convert angular frequency to hertz
        
        if const.isComputeGroupVelocity
            for wv_comp_idx = 1:2
                for eig_idx = 1:const.N_eig
                    omega = fr(k_idx,eig_idx);
                    u = eig_vecs(:,eig_idx);
                    cg(k_idx,wv_comp_idx,eig_idx) = full(1/(2*omega).*(u'*(dKrdwavevector(:,:,wv_comp_idx) - omega^2*dMrdwavevector(:,:,wv_comp_idx))*u))/(eig_vecs(:,eig_idx)'*Mr*eig_vecs(:,eig_idx));
%                     dK = full(dKrdwavevector); dM = full(dMrdwavevector);
%                     cg(k_idx,wv_comp_idx,eig_idx) = full(1/(2*omega).*(u'*(dK(:,:,wv_comp_idx) - omega^2*dM(:,:,wv_comp_idx))*u)); % /(eig_vecs(:,eig_idx)'*Mr*eig_vecs(:,eig_idx))
                    imag_tol = 1e-6;
                    if abs(imag(cg(k_idx,wv_comp_idx,eig_idx))) > imag_tol
                        warning('large imaginary group velocity component')
                    end
                    cg(k_idx,wv_comp_idx,eig_idx) = real(cg(k_idx,wv_comp_idx,eig_idx));
                end
            end
        else
            cg = [];
        end
        
        if const.isComputeDesignSensitivity
            design_size = size(const.design);
            design_size(3) = design_size(3) - 1; % Poisson's ratio is not a design variable here
            dKrddesign = ndSparse.build([size(Kr) design_size]);
            dMrddesign = ndSparse.build([size(Mr) design_size]);
            dfrddesign = zeros([size(wavevectors,2) const.N_eig design_size]);
            for i = 1:design_size(1)
                for j = 1:design_size(2)
                    for k = 1:design_size(3)
                        if k == 1
%                             dKrddesign(:,:,i,j,k) = T'*dKddesign(:,:,i,j,k)*T;
                            dKrddesign(:,:,i,j) = T'*dKddesign(:,:,i,j)*T;
                            for eig_idx = 1:const.N_eig
                                omega = fr(k_idx,eig_idx);
                                u = eig_vecs(:,eig_idx);
%                                 dfrddesign(k_idx,eig_idx,i,j,k) = 1/(2*omega) * u'*(dKrddesign(:,:,i,j,k) - omega^2*dMrddesign(:,:,i,j,k))*u;
                                dfrddesign(k_idx,eig_idx,i,j,k) = 1/(2*omega) * u'*(dKrddesign(:,:,i,j))*u;
                                imag_tol = 1e-6;
                                if any(abs(imag(dfrddesign(k_idx,eig_idx,i,j,k))) > imag_tol)
                                    warning('dfrddesign has large imaginary components')
                                end
                                dfrddesign(k_idx,eig_idx,i,j,k) = real(dfrddesign(k_idx,eig_idx,i,j,k));
                            end
                        elseif k == 2
%                             dMrddesign(:,:,i,j,k) = T'*dMddesign(:,:,i,j,k)*T;
                            dMrddesign(:,:,i,j) = T'*dMddesign(:,:,i,j)*T;
                            for eig_idx = 1:const.N_eig
                                omega = fr(k_idx,eig_idx);
                                u = eig_vecs(:,eig_idx);
%                                 dfrddesign(k_idx,eig_idx,i,j,k) = 1/(2*omega) * u'*(dKrddesign(:,:,i,j,k) - omega^2*dMrddesign(:,:,i,j,k))*u;
                                dfrddesign(k_idx,eig_idx,i,j,k) = 1/(2*omega) * u'*(-omega^2*dMrddesign(:,:,i,j))*u;
                                imag_tol = 1e-6;
                                if any(abs(imag(dfrddesign(k_idx,eig_idx,i,j,k))) > imag_tol)
                                    warning('dfrddesign has large imaginary components')
                                end
                                dfrddesign(k_idx,eig_idx,i,j,k) = real(dfrddesign(k_idx,eig_idx,i,j,k));
                            end
                        end
                    end
                end
            end
        end
        %% compute dcgddesign next ... 
    end
    wv = wavevectors;
end


