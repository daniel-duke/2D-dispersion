function [Kr,Mr] = get_reduced_matrices(wavevector,const)
    
    N_node = (const.N_ele*const.N_pix) + 1;
    N_node_reduced = N_node - 1;
    N_dof = 2*(N_node^2);
    N_dof_reduced = 2*(N_node_reduced^2);
    
    if const.isUseFastT
%     T = sparse(N_dof,N_dof_reduced);
    row_idxs = zeros(N_dof,1);
    col_idxs = zeros(N_dof,1);
    value_T = zeros(N_dof,1);
    
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
    
%     for i = 1:(N_node-1)
%         T(global_dof_idxs(2*i - 1),reduced_global_dof_idxs(2*i - 1)) = xphase;
%         T(global_dof_idxs(2*i),reduced_global_dof_idxs(2*i)) = xphase;
%     end
    
    N_dof_per_node = 2;
    start_pointer = 1;
    end_pointer = N_dof_per_node*N_node_reduced;
    row_idxs(start_pointer:end_pointer) = global_dof_idxs';
    col_idxs(start_pointer:end_pointer) = reduced_global_dof_idxs';
    value_T(start_pointer:end_pointer) = xphase;
    
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
    
%     for i = 1:(N_node-1)
%         T(global_dof_idxs(2*i - 1),reduced_global_dof_idxs(2*i - 1)) = yphase;
%         T(global_dof_idxs(2*i),reduced_global_dof_idxs(2*i)) = yphase;
%     end
    
    start_pointer = end_pointer + 1;
    end_pointer = start_pointer + N_dof_per_node*N_node_reduced - 1;
    row_idxs(start_pointer:end_pointer) = global_dof_idxs';
    col_idxs(start_pointer:end_pointer) = reduced_global_dof_idxs';
    value_T(start_pointer:end_pointer) = yphase;
    
    % corner node
    node_idx_x = N_node;
    node_idx_y = N_node;
    global_node_idx = (node_idx_y - 1)*N_node + node_idx_x;
    global_dof_idxs(1:2) = (2*global_node_idx - 1):(2*global_node_idx);
    
    node_idx_x = 1;
    node_idx_y = 1;
    reduced_global_node_idx = (node_idx_y - 1)*(N_node - 1) + node_idx_x;
    reduced_global_dof_idxs(1:2) = (2*reduced_global_node_idx - 1):(2*reduced_global_node_idx);
    
%     T(global_dof_idxs(1),reduced_global_dof_idxs(1)) = cornerphase;
%     T(global_dof_idxs(2),reduced_global_dof_idxs(2)) = cornerphase;
    
    start_pointer = end_pointer + 1;
    end_pointer = start_pointer + N_dof_per_node*1 - 1;
    row_idxs(start_pointer:end_pointer) = global_dof_idxs(1:2)';
    col_idxs(start_pointer:end_pointer) = reduced_global_dof_idxs(1:2)';
    value_T(start_pointer:end_pointer) = cornerphase;
    
    % unchanged nodes
    for node_idx_x = 1:(N_node-1);
        for node_idx_y = 1:(N_node-1);
            
            global_node_idx = (node_idx_y - 1)*N_node + node_idx_x;
            global_dof_idxs(1:2) = (2*global_node_idx - 1):(2*global_node_idx);

            reduced_global_node_idx = (node_idx_y - 1)*(N_node - 1) + node_idx_x;
            reduced_global_dof_idxs(1:2) = (2*reduced_global_node_idx - 1):(2*reduced_global_node_idx);
            
            start_pointer = end_pointer + 1;
            end_pointer = start_pointer + N_dof_per_node*1 - 1;
            row_idxs(start_pointer:end_pointer) = global_dof_idxs(1:2)';
            col_idxs(start_pointer:end_pointer) = reduced_global_dof_idxs(1:2)';
            value_T(start_pointer:end_pointer) = 1;

%             T(global_dof_idxs(1),reduced_global_dof_idxs(1)) = 1;
%             T(global_dof_idxs(2),reduced_global_dof_idxs(2)) = 1;
        end
    end
    
    T = sparse(row_idxs,col_idxs,value_T);
    elseif ~const.isUseFastT
        %     T = sparse(N_dof,N_dof_reduced);
    row_idxs = zeros(N_dof,1);
    col_idxs = zeros(N_dof,1);
    value_T = zeros(N_dof,1);
    
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
    
%     for i = 1:(N_node-1)
%         T(global_dof_idxs(2*i - 1),reduced_global_dof_idxs(2*i - 1)) = xphase;
%         T(global_dof_idxs(2*i),reduced_global_dof_idxs(2*i)) = xphase;
%     end
    
    N_dof_per_node = 2;
    start_pointer = 1;
    end_pointer = N_dof_per_node*N_node_reduced;
    row_idxs(start_pointer:end_pointer) = global_dof_idxs';
    col_idxs(start_pointer:end_pointer) = reduced_global_dof_idxs';
    value_T(start_pointer:end_pointer) = xphase;
    
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
    
    end
    
end