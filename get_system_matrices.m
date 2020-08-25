function [K,M] = get_system_matrices(const)
    
    N_ele_x = const.N_pix*const.N_ele; % Total number of elements along x direction
    N_ele_y = const.N_pix*const.N_ele; % Total number of elements along y direction
    N_nodes_x = N_ele_x + 1; N_nodes_y = N_ele_y + 1; % add one since a system with 3 elements along an edge would actually have 4 nodes. Subtract one because DOF at right boundary will be slaved to DOF at left boundary
    N_dof = (N_nodes_x*N_nodes_y)*2; % 2 DOF per node
    K = sparse(N_dof,N_dof);
    M = sparse(N_dof,N_dof);
    for ele_idx_x = 1:N_ele_x
        for ele_idx_y = 1:N_ele_y
            
            seg_idx_x = ceil(ele_idx_x/const.N_ele);
            seg_idx_y = ceil(ele_idx_y/const.N_ele);
            
            E = const.E_min + const.design(seg_idx_y,seg_idx_x,1)*(const.E_max - const.E_min);
            nu = const.poisson_min + const.design(seg_idx_y,seg_idx_x,3)*(const.poisson_max - const.poisson_min);
            t = const.t;
            rho = const.rho_min + const.design(seg_idx_y,seg_idx_x,2)*(const.rho_max - const.rho_min);
            
            %             bool_condition = [ele_idx_x == N_ele_x ele_idx_y
            %             == N_ele_y];
            %
            %             if all(bool_condition == [0 0]) condition =
            %             'normal'; elseif all(bool_condition == [1 0])
            %                 condition = 'rightboundary';
            %             elseif all(bool_condition == [0 1])
            %                 condition = 'bottomboundary';
            %             elseif all(bool_condition == [1 1])
            %                 condition = 'bottomrightcorner';
            %             end
            
            k_ele = get_element_stiffness(E,nu,t,const);
            m_ele = get_element_mass(rho,t,const);
            global_idxs = get_global_idxs(ele_idx_x,ele_idx_y,'normal',const);
            
            K(global_idxs,global_idxs) = K(global_idxs,global_idxs) + k_ele;
            M(global_idxs,global_idxs) = M(global_idxs,global_idxs) + m_ele;
            %             switch condition
            %                 case 'normal'
            %
            %
            %
            %
            %                 otherwise
            %                     k_ele =
            %                     apply_bloch_floquet(k_ele,condition,wavevector,const);
            % %                     global_idxs =
            % get_global_idxs(ele_idx_x,ele_idx_y,condition,const);
            %                     if length(global_idxs) ==
            %                     length(unique(global_idxs))
            %                         K(global_idxs,global_idxs) =
            %                         K(global_idxs,global_idxs) + k_ele;
            %                         M(global_idxs,global_idxs) =
            %                         M(global_idxs,global_idxs) + m_ele;
            %                     else
            %                         disp('global_idxs has repeated
            %                         indices - performing addition the
            %                         ugly way') for i =
            %                         1:length(global_idxs)
            %                             for j = 1:length(global_idxs)
            %                                 K(global_idxs(i),global_idxs(j))
            %                                 =
            %                                 K(global_idxs(i),global_idxs(j))
            %                                 + k_ele(i,j);
            %                                 M(global_idxs(i),global_idxs(j))
            %                                 =
            %                                 M(global_idxs(i),global_idxs(j))
            %                                 + m_ele(i,j);
            %                             end
            %                         end
            %                     end
            %             end
        end
    end
end