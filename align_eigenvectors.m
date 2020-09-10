function [ev,theta] = align_eigenvectors(ev,const)
    theta = zeros(const.N_eig,size(ev,2) - 1);
    for eig_idx = 1:const.N_eig
        for k_idx = 1:(size(ev,2) - 1)
            theta(eig_idx,k_idx) = angle2(abs(squeeze(ev(eig_idx,k_idx + 1,:))),abs(squeeze(ev(eig_idx,k_idx,:))));
            if theta(eig_idx,k_idx) > pi/2
                ev(eig_idx,k_idx + 1,:) = -ev(eig_idx,k_idx + 1,:);
                theta(eig_idx,k_idx) = pi - theta(eig_idx,k_idx);
            end
        end
    end
end