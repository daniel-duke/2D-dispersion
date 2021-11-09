function [wv_MG,wv_GX,wv_XM,fr] = dispersion_complexwn(const, fr)
% Purpose: Compute complex dispersion curves
% -----------------------------------------------
% Input:
% const: design structure
% fr: frequency in hertz
% -----------------------------------------------
% Output:
% wv_MG, wv_GX, wv_XM: computed complex wave vectors
% fr: Corresponding frequency values
% -----------------------------------------------


if const.isUseImprovement
    [K,M] = get_system_matrices_VEC(const);
else
    [K,M] = get_system_matrices(const);
end
if const.isUseParallel
    parforArg = Inf;
else
    parforArg = 0;
end



N_node = (const.N_ele*const.N_pix) + 1;



%for w_idx = 1:size(fr,2) % USE THIS TO DEBUG
parfor (w_idx = 1:size(fr,2), parforArg)
    D = K - (4*pi^2*fr(w_idx)^2)*M;
    [D0,D1,D2,D3,D4,D5,D6,D7,D8] = reduce_partition_DS_matrix(const.Nod_dof,N_node,D);
    n = size(D0,1);
    n_fac = 2; % portion of evalues to be used


%     if ~const.isUseGPU
        % DONT USE THE GPU WITH EIGS


        % First: M -> Gamma - lambda_y = 1
        A0 = D0+D2+D8;
        A1 = D1+D3+D5;
        A1 = 1/2*(A1+A1');%symmetrize to avoid round up errors
        A2 = A0'; %D4+D6+D7;
        
        % Linearized EVP
        %         L = [A0, zeros(n); zeros(n) eye(n)];
        %         R = [-A1 -A2; eye(n) zeros(n)];
        %         [eig_vecs_MG,lambda_MG] = eig(L,R);
        %         lambda_MG = diag(lambda_MG);
        
        % Polynomial EVP
        [eig_vecs_MG,lambda_MG] = polyeig(A0,A1,A2);
        wv_MG(:,w_idx) = 1i*log(lambda_MG(1:floor(n*n_fac)));
        
        % Second: Gamma -> X - lambda_x = -1
        A0 = D0-D1+D7;
        A1 = D2-D3+D4;
        A1 = 1/2*(A1+A1');%symmetrize to avoid round up errors
        A2 = A0';%-D5+D6+D8;
        
        %         % Linearized EVP
        %         L = [A0, zeros(n); zeros(n) eye(n)];
        %         R = [-A1 -A2; eye(n) zeros(n)];
        %         [eig_vecs_GX,lambda_GX] = eig(L,R);
        %         lambda_GX = diag(lambda_GX);
        
        % Polynomial EVP
        [eig_vecs_GX,lambda_GX] = polyeig(A0,A1,A2);
        wv_GX(:,w_idx) = 1i*log(lambda_GX(1:floor(n*n_fac)));
        
        % Third: M -> Gamma - lambda_x = lambda_y
        A0 = D0;
        A1 = D1+D2;
        A2 = D3+D7+D8;
        A2 = 1/2*(A2+A2');
        A3 = A1';%D4+D5;
        A4 = A0';%D6;
        
        % Linearized EVP
        %L =
        %R =
        %[eig_vecs_XM,lambda_XM] = eig(L,R);
        
        % Polynomial EVP
        [eig_vecs_XM,lambda_XM] = polyeig(A0,A1,A2,A3,A4);
        wv_XM(:,w_idx) = 1i*log(lambda_XM(1:floor(n*2*n_fac)));
        
        % Normalization and sorting
        %[kx_eig_vals,idxs] = sort(diag(kx_eig_vals));
        %[kx_eig_vals,idxs] = sort(kx_eig_vals);
        %k_eig_vecs_GX = k_eig_vecs_GX(:,idxs);
        %ev(:,k_idx,:) = (eig_vecs./(diag(eig_vecs'*Mr*eig_vecs)'))'; % normalize by mass matrix
        %ev(:,w_idx,:) = (kx_eig_vecs./vecnorm(kx_eig_vecs,2,1)).*...
        %exp(-1i*angle(kx_eig_vecs(1,:))); % normalize by p-norm, align complex angle
        %ev(:,k_idx,:) = (eig_vecs./max(eig_vecs))'; % normalize by max
        %ev(:,k_idx,:) = eig_vecs'; % don't normalize
        
        
        
        
%     elseif const.isUseGPU
%         % USE THE GPU WITH EIG
%         error('GPU use is not currently developed');
%         MinvK_gpu = gpuArray(full(inv(Mr)*Kr));
%         [eig_vecs,lambda] = eig(MinvK_gpu);
%         [lambda,idxs] = sort(diag(lambda));
%         eig_vecs = eig_vecs(:,idxs);
%         fr(k_idx,:) = sqrt(real(lambda(1:const.N_eig)));
%         fr(k_idx,:) = fr(k_idx,:)/(2*pi);
%     end
end
end


