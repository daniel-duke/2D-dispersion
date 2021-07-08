function global_idxs = get_global_idxs(ele_idx_x,ele_idx_y,const)
    global_idxs = zeros(const.Nod_dof*4,1);
    N_node_y = (const.N_ele*const.N_pix) + 1;
    
    % node 1
    node_idx_y = ele_idx_y + 1; node_idx_x = ele_idx_x;
    global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
    nod_ind = 1:const.Nod_dof; % for node 1
    if const.Nod_dof == 2
        global_idxs(nod_ind) = ...
            (const.Nod_dof*global_node_idx - 1):(const.Nod_dof*global_node_idx);
    elseif const.Nod_dof == 1
        global_idxs(nod_ind) = (const.Nod_dof*global_node_idx);
    end
    
    % node 2
    node_idx_y = ele_idx_y + 1; node_idx_x = ele_idx_x + 1;
    global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
    nod_ind = const.Nod_dof+1:2*const.Nod_dof; % for node 2
    if const.Nod_dof == 2
        global_idxs(nod_ind) = ...
            (const.Nod_dof*global_node_idx - 1):(const.Nod_dof*global_node_idx);
    elseif const.Nod_dof == 1
        global_idxs(nod_ind) = (const.Nod_dof*global_node_idx);
    end
    
    % node 3
    node_idx_y = ele_idx_y; node_idx_x = ele_idx_x + 1;
    global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
    nod_ind = 2*const.Nod_dof+1:3*const.Nod_dof; % for node 3
    if const.Nod_dof == 2
        global_idxs(nod_ind) = ...
            (const.Nod_dof*global_node_idx - 1):(const.Nod_dof*global_node_idx);
    elseif const.Nod_dof == 1
        global_idxs(nod_ind) = (const.Nod_dof*global_node_idx);
    end
    
    % node 4
    node_idx_y = ele_idx_y; node_idx_x = ele_idx_x;
    global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
    nod_ind = 3*const.Nod_dof+1:4*const.Nod_dof; % for node 4
    if const.Nod_dof == 2
        global_idxs(nod_ind) = ...
            (const.Nod_dof*global_node_idx - 1):(const.Nod_dof*global_node_idx);
    elseif const.Nod_dof == 1
        global_idxs(nod_ind) = (const.Nod_dof*global_node_idx);
    end
end
