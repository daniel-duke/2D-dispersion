function global_idxs = get_global_idxs(ele_idx_x,ele_idx_y,condition,const)
    global_idxs = zeros(8,1);
%     N_node_x = (const.N_ele*const.N_pix) + 1 - 1;
    N_node_y = (const.N_ele*const.N_pix) + 1;
    switch condition
        case 'normal' % we're not at the right boundary nor the bottom boundary
            % in order of local node numbers node 1
            node_idx_y = ele_idx_y + 1; node_idx_x = ele_idx_x;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(1:2) = (2*global_node_idx - 1):(2*global_node_idx);
            
            % node 2
            node_idx_y = ele_idx_y + 1; node_idx_x = ele_idx_x + 1;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(3:4) = (2*global_node_idx - 1):(2*global_node_idx);
            
            % node 3
            node_idx_y = ele_idx_y; node_idx_x = ele_idx_x + 1;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(5:6) = (2*global_node_idx - 1):(2*global_node_idx);
            
            % node 4
            node_idx_y = ele_idx_y; node_idx_x = ele_idx_x;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(7:8) = (2*global_node_idx - 1):(2*global_node_idx);
        case 'rightboundary' % means we're at the right boundary
            % in order of local node numbers node 1
            node_idx_y = ele_idx_y + 1; node_idx_x = ele_idx_x;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(1:2) = (2*global_node_idx - 1):(2*global_node_idx);
            
            % node 2
            node_idx_y = ele_idx_y + 1; node_idx_x = 1;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(3:4) = (2*global_node_idx - 1):(2*global_node_idx);
            
            % node 3
            node_idx_y = ele_idx_y; node_idx_x = 1;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(5:6) = (2*global_node_idx - 1):(2*global_node_idx);
            
            % node 4
            node_idx_y = ele_idx_y; node_idx_x = ele_idx_x;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(7:8) = (2*global_node_idx - 1):(2*global_node_idx);
        case 'bottomboundary' % means we're at the bottom boundary
            % in order of local node numbers node 1
            node_idx_y = 1; node_idx_x = ele_idx_x;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(1:2) = (2*global_node_idx - 1):(2*global_node_idx);
            
            % node 2
            node_idx_y = 1; node_idx_x = ele_idx_x + 1;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(3:4) = (2*global_node_idx - 1):(2*global_node_idx);
            
            % node 3
            node_idx_y = ele_idx_y; node_idx_x = ele_idx_x + 1;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(5:6) = (2*global_node_idx - 1):(2*global_node_idx);
            
            % node 4
            node_idx_y = ele_idx_y; node_idx_x = ele_idx_x;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(7:8) = (2*global_node_idx - 1):(2*global_node_idx);
        case 'bottomrightcorner' % means we're at the bottom right corner
            % in order of local node numbers node 1
            node_idx_y = 1; node_idx_x = ele_idx_x;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(1:2) = (2*global_node_idx - 1):(2*global_node_idx);
            
            % node 2
            node_idx_y = 1; node_idx_x = 1;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(3:4) = (2*global_node_idx - 1):(2*global_node_idx);
            
            % node 3
            node_idx_y = ele_idx_y; node_idx_x = 1;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(5:6) = (2*global_node_idx - 1):(2*global_node_idx);
            
            % node 4
            node_idx_y = ele_idx_y; node_idx_x = ele_idx_x;
            global_node_idx = (node_idx_y - 1)*N_node_y + node_idx_x;
            global_idxs(7:8) = (2*global_node_idx - 1):(2*global_node_idx);
    end
end