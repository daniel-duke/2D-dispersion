function m_ele = get_element_mass_VEC(rho,t,const)
    % dof are [ u1 v1 u2 v2 u3 v3 u4 v4 ] (indexing starts with lower left
    % node and goes counterclockwise, as is standard in FEM)
    
    m = rho.*t*(const.a/(const.N_ele*const.N_pix))^2; % total mass of this element
    m_ele = (1/36)*m.*[...
        4 0 2 0 1 0 2 0,...
        0 4 0 2 0 1 0 2,...
        2 0 4 0 2 0 1 0,...
        0 2 0 4 0 2 0 1,...
        1 0 2 0 4 0 2 0,...
        0 1 0 2 0 4 0 2,...
        2 0 1 0 2 0 4 0,...
        0 2 0 1 0 2 0 4];
end
