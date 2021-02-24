function [K,M,dKddesign,dMddesign] = get_system_matrices(const)
    
    N_ele_x = const.N_pix*const.N_ele; % Total number of elements along x direction
    N_ele_y = const.N_pix*const.N_ele; % Total number of elements along y direction
    N_nodes_x = N_ele_x + 1; N_nodes_y = N_ele_y + 1; % add one since a system with 3 elements along an edge would actually have 4 nodes along that edge.
    N_dof = (N_nodes_x*N_nodes_y)*2; % 2 DOF per node
    
    N_dof_per_element = 8;
    row_idxs = zeros(N_dof_per_element*(const.N_ele*const.N_pix)^2,1);
    col_idxs = zeros(N_dof_per_element*(const.N_ele*const.N_pix)^2,1);
    value_K = zeros(N_dof_per_element*(const.N_ele*const.N_pix)^2,1);
    value_M = zeros(N_dof_per_element*(const.N_ele*const.N_pix)^2,1);
    if nargout == 4
       xpix_idxs = zeros(N_dof_per_element*(const.N_ele*const.N_pix)^2,1);
       ypix_idxs = zeros(N_dof_per_element*(const.N_ele*const.N_pix)^2,1);
       value_dKddesign = zeros(N_dof_per_element*(const.N_ele*const.N_pix)^2,1);
       value_dMddesign = zeros(N_dof_per_element*(const.N_ele*const.N_pix)^2,1);
    end
    for ele_idx_x = 1:N_ele_x
        for ele_idx_y = 1:N_ele_y
            pix_idx_x = ceil(ele_idx_x./const.N_ele);
            pix_idx_y = ceil(ele_idx_y./const.N_ele);
            
            E = const.E_min + const.design(pix_idx_y,pix_idx_x,1)*(const.E_max - const.E_min);
            nu = const.poisson_min + const.design(pix_idx_y,pix_idx_x,3)*(const.poisson_max - const.poisson_min);
            t = const.t;
            rho = const.rho_min + const.design(pix_idx_y,pix_idx_x,2)*(const.rho_max - const.rho_min);
            
            k_ele = get_element_stiffness(E,nu,t,const);
            m_ele = get_element_mass(rho,t,const);
            global_idxs = get_global_idxs(ele_idx_x,ele_idx_y,const);
            
            start_pointer = (N_dof_per_element^2)*(((ele_idx_x - 1)*N_ele_x + ele_idx_y) - 1) + 1;
            end_pointer = (N_dof_per_element^2)*((ele_idx_x - 1)*N_ele_x + ele_idx_y);
            global_idxs_mat = repmat(global_idxs,1,size(global_idxs,1));
            
            row_idxs(start_pointer:end_pointer) = reshape(global_idxs_mat,64,1);
            col_idxs(start_pointer:end_pointer) = reshape(global_idxs_mat',64,1);
            value_K(start_pointer:end_pointer) = reshape(k_ele,64,1);
            value_M(start_pointer:end_pointer) = reshape(m_ele,64,1);
            
            if nargout == 4
                dk_eleddesign = get_element_stiffness_sensitivity(E,nu,t,const);
                dm_eleddesign = get_element_mass_sensitivity(rho,t,const);
                value_dKddesign(start_pointer:end_pointer) = reshape(dk_eleddesign,64,1);
                value_dMddesign(start_pointer:end_pointer) = reshape(dm_eleddesign,64,1);
                xpix_idxs(start_pointer:end_pointer) = pix_idx_x*ones(64,1);
                ypix_idxs(start_pointer:end_pointer) = pix_idx_y*ones(64,1);
            end
        end
    end
    K = sparse(row_idxs,col_idxs,value_K);
    M = sparse(row_idxs,col_idxs,value_M);
    
    if nargout == 4
%        dKddesign = ndSparse.build([row_idxs col_idxs xpix_idxs ypix_idxs 1*ones(size(row_idxs,1),1)],value_dKddesign);
%        dMddesign = ndSparse.build([row_idxs col_idxs xpix_idxs ypix_idxs 2*ones(size(row_idxs,1),1)],value_dMddesign);
       dKddesign = ndSparse.build([row_idxs col_idxs xpix_idxs ypix_idxs],value_dKddesign);
       dMddesign = ndSparse.build([row_idxs col_idxs xpix_idxs ypix_idxs],value_dMddesign);
%        dKddesign = ndSparse.build([row_idxs col_idxs xpix_idxs ypix_idxs 1*ones(size(row_idxs,1),1)],value_dKddesign,[max(row_idxs) max(col_idxs) const.N_pix const.N_pix 2]);
%        dMddesign = ndSparse.build([row_idxs col_idxs xpix_idxs ypix_idxs 2*ones(size(row_idxs,1),1)],value_dMddesign);
    end
end