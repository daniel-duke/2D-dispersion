function T = get_transformation_matrix(wavevector,const)
    
    N_node = (const.N_ele*const.N_pix) + 1;
    N_node_reduced = N_node - 1;
    N_dof = 2*(N_node^2);
    N_dof_reduced = 2*(N_node_reduced^2);
    
    if ~const.isUseImprovement
        T = sparse(N_dof,N_dof_reduced);
        
        r = [const.a; 0];
        xphase = exp(1i*dot(wavevector,r));
        
        r = [0; -const.a];
        yphase = exp(1i*dot(wavevector,r));
        
        r = [const.a; -const.a];
        cornerphase = exp(1i*dot(wavevector,r));
        
        % sidenodes
        node_idx_x = N_node;
        node_idx_y = 1:(N_node-1);
        global_node_idx = (node_idx_y - 1)*N_node + node_idx_x;
        for i = 1:(N_node-1)
            global_dof_idxs((2*i - 1):(2*i)) = (2*global_node_idx(i) - 1):(2*global_node_idx(i));
        end
        
        node_idx_x = 1;
        node_idx_y = 1:(N_node-1);
        reduced_global_node_idx = (node_idx_y - 1)*(N_node - 1) + node_idx_x;
        for i = 1:(N_node-1)
            reduced_global_dof_idxs((2*i - 1):(2*i)) = (2*reduced_global_node_idx(i) - 1):(2*reduced_global_node_idx(i));
        end
        
        for i = 1:(N_node-1)
            T(global_dof_idxs(2*i - 1),reduced_global_dof_idxs(2*i - 1)) = xphase;
            T(global_dof_idxs(2*i),reduced_global_dof_idxs(2*i)) = xphase;
        end
        
        
        % bottom nodes
        node_idx_x = 1:(N_node-1);
        node_idx_y = N_node;
        global_node_idx = (node_idx_y - 1)*N_node + node_idx_x;
        for i = 1:(N_node-1)
            global_dof_idxs((2*i - 1):(2*i)) = (2*global_node_idx(i) - 1):(2*global_node_idx(i));
        end
        
        node_idx_x = 1:(N_node-1);
        node_idx_y = 1;
        reduced_global_node_idx = (node_idx_y - 1)*(N_node - 1) + node_idx_x;
        for i = 1:(N_node-1)
            reduced_global_dof_idxs((2*i - 1):(2*i)) = (2*reduced_global_node_idx(i) - 1):(2*reduced_global_node_idx(i));
        end
        
        for i = 1:(N_node-1)
            T(global_dof_idxs(2*i - 1),reduced_global_dof_idxs(2*i - 1)) = yphase;
            T(global_dof_idxs(2*i),reduced_global_dof_idxs(2*i)) = yphase;
        end
        
        
        % corner node
        node_idx_x = N_node;
        node_idx_y = N_node;
        global_node_idx = (node_idx_y - 1)*N_node + node_idx_x;
        global_dof_idxs(1:2) = (2*global_node_idx - 1):(2*global_node_idx);
        
        node_idx_x = 1;
        node_idx_y = 1;
        reduced_global_node_idx = (node_idx_y - 1)*(N_node - 1) + node_idx_x;
        reduced_global_dof_idxs(1:2) = (2*reduced_global_node_idx - 1):(2*reduced_global_node_idx);
        
        T(global_dof_idxs(1),reduced_global_dof_idxs(1)) = cornerphase;
        T(global_dof_idxs(2),reduced_global_dof_idxs(2)) = cornerphase;
        
        
        % unchanged nodes
        for node_idx_x = 1:(N_node-1);
            for node_idx_y = 1:(N_node-1);
                
                global_node_idx = (node_idx_y - 1)*N_node + node_idx_x;
                global_dof_idxs(1:2) = (2*global_node_idx - 1):(2*global_node_idx);
                
                reduced_global_node_idx = (node_idx_y - 1)*(N_node - 1) + node_idx_x;
                reduced_global_dof_idxs(1:2) = (2*reduced_global_node_idx - 1):(2*reduced_global_node_idx);
                
                
                T(global_dof_idxs(1),reduced_global_dof_idxs(1)) = 1;
                T(global_dof_idxs(2),reduced_global_dof_idxs(2)) = 1;
            end
        end
        
    else
        
        row_idxs = zeros(N_dof,1);
        col_idxs = zeros(N_dof,1);
        value_T = zeros(N_dof,1);
        
        r = [const.a; 0];
        xphase = exp(1i*dot(wavevector,r));
        
        r = [0; -const.a];
        yphase = exp(1i*dot(wavevector,r));
        
        r = [const.a; -const.a];
        cornerphase = exp(1i*dot(wavevector,r));
        
        % all at once.
        
        node_idx_x = [reshape(meshgrid(1:(N_node-1),1:(N_node - 1)),[],1)' N_node*ones(1,N_node - 1) 1:(N_node-1) N_node];
        node_idx_y = [reshape(meshgrid(1:(N_node-1),1:(N_node - 1))',[],1)' 1:(N_node-1) N_node*ones(1,N_node - 1) N_node];
        global_node_idx = (node_idx_y - 1)*N_node + node_idx_x;
        global_dof_idxs = [2*global_node_idx - 1 2*global_node_idx];
        unch_idxs = 1:((N_node-1)^2);
        x_idxs = (((N_node-1)^2) + 1):(((N_node-1)^2) + 1 + N_node - 2);
        y_idxs = (((N_node-1)^2) + N_node):(((N_node-1)^2) + N_node + N_node - 2);
        %         corner_idxs = (((N_node-1)^2) + N_node + N_node):(((N_node-1)^2) + N_node + N_node + 1);
        reduced_global_node_idx = [(node_idx_y(unch_idxs) - 1)*(N_node - 1) + node_idx_x(unch_idxs)...
            (node_idx_y(x_idxs) - 1)*(N_node - 1) + node_idx_x(x_idxs) - (N_node - 1) ...
            node_idx_x(y_idxs)...
            1];
        reduced_global_dof_idxs = [2*reduced_global_node_idx - 1 2*reduced_global_node_idx];
        
        row_idxs = global_dof_idxs';
        col_idxs = reduced_global_dof_idxs';
        value_T = repmat([ones((N_node-1)^2,1); xphase*ones(N_node - 1,1); yphase*ones(N_node - 1,1); cornerphase],2,1);
        
        T = sparse(row_idxs,col_idxs,value_T);
    end
    
end

