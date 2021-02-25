function dm_eleddesign = get_element_mass_sensitivity(rho,t,const)
    % dof are [ u1 v1 u2 v2 u3 v3 u4 v4 ] (indexing starts with lower left
    % node and goes counterclockwise, as is standard in FEM)
    
    dmdrho = t*(const.a/(const.N_ele*const.N_pix))^2; % derivative of the total mass of this element with respect to the density of the element
    drhoddesign = const.rho_max - const.rho_min;
    dm_eleddesign = (1/36)*dmdrho*...
        [...
        [4 0 2 0 1 0 2 0];
        [0 4 0 2 0 1 0 2];
        [2 0 4 0 2 0 1 0];
        [0 2 0 4 0 2 0 1];
        [1 0 2 0 4 0 2 0];
        [0 1 0 2 0 4 0 2];
        [2 0 1 0 2 0 4 0];
        [0 2 0 1 0 2 0 4]...
        ];
end