function [Kr,Mr] = get_reduced_matrices(K,M,wavevector,const)
    
    N_node = (const.N_ele*const.N_pix) + 1;
    N_dof = 2*(N_node^2);
    N_dof_reduced = 2*((N_node-1)^2);
    
    T = zeros(N_dof,N_dof_reduced);
    
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
    
    T(global_dof_idxs(1:2:end),reduced_global_dof_idxs(1:2:end)) = xphase;
    T(global_dof_idxs(2:2:end),reduced_global_dof_idxs(2:2:end)) = xphase;
    
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
    
    T(global_dof_idxs(1:2:end),reduced_global_dof_idxs(1:2:end)) = yphase;
    T(global_dof_idxs(2:2:end),reduced_global_dof_idxs(2:2:end)) = yphase;
    
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
    counter = 1;
    for node_idx_x = 1:(N_node-1);
        for node_idx_y = 1:(N_node-1);
            
            global_node_idx = (node_idx_y - 1)*N_node + node_idx_x;
            global_dof_idxs(counter:(counter+1)) = (2*global_node_idx - 1):(2*global_node_idx);

            reduced_global_node_idx = (node_idx_y - 1)*(N_node - 1) + node_idx_x;
            reduced_global_dof_idxs(counter:(counter+1)) = (2*reduced_global_node_idx - 1):(2*reduced_global_node_idx);

            T(global_dof_idxs(1:2:end),reduced_global_dof_idxs(1:2:end)) = 1;
            T(global_dof_idxs(2:2:end),reduced_global_dof_idxs(2:2:end)) = 1;
            counter = counter + 2;
        end
    end
    
    Kr = T'*K*T;
    Mr = T'*M*T;
end