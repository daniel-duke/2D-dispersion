function T = get_transformation_matrix(wavevector,const)
    
    N_node = (const.N_ele*const.N_pix) + 1;
    N_node_reduced = N_node - 1;
    N_dof = 2*(N_node^2);
    N_dof_reduced = 2*(N_node_reduced^2);
            
    row_idxs = zeros(N_dof,1);
    col_idxs = zeros(N_dof,1);
    value_T = zeros(N_dof,1);
    
    r = [const.a; 0];
    xphase = exp(1i*dot(wavevector,r));
    
    r = [0; -const.a];
    yphase = exp(1i*dot(wavevector,r));
    
    r = [const.a; -const.a];
    cornerphase = exp(1i*dot(wavevector,r));
    
    node_idx_x = [reshape(meshgrid(1:(N_node-1),1:(N_node - 1)),[],1)' N_node*ones(1,N_node - 1) 1:(N_node-1) N_node];
    node_idx_y = [reshape(meshgrid(1:(N_node-1),1:(N_node - 1))',[],1)' 1:(N_node-1) N_node*ones(1,N_node - 1) N_node];
    global_node_idx = (node_idx_y - 1)*N_node + node_idx_x;
    global_dof_idxs = [2*global_node_idx - 1 2*global_node_idx];
    unch_idxs = 1:((N_node-1)^2);
    x_idxs = (((N_node-1)^2) + 1):(((N_node-1)^2) + 1 + N_node - 2);
    y_idxs = (((N_node-1)^2) + N_node):(((N_node-1)^2) + N_node + N_node - 2);

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

