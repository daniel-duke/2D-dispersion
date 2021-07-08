function k_ele = get_element_stiffness(E,nu,t,const)
    % node and goes counterclockwise, as is standard in FEM)
    
    % ELEMENT INFORMATION: Q4 bilinear quad element full integration
    if const.Nod_dof == 2 %Plane stress PSV
            % dof are [ u1 v1 u2 v2 u3 v3 u4 v4 ] (indexing starts with lower left

    k_ele = (1/48)*E*t/(1-nu^2)*...
        [...
        [24-8*nu , 6*nu+6  , -12-4*nu, 18*nu-6 , -12+4*nu, -6*nu-6 , 8*nu    , -18*nu+6];
        [6*nu+6  , 24-8*nu , -18*nu+6, 8*nu    , -6*nu-6 , -12+4*nu, 18*nu-6 , -12-4*nu];
        [-12-4*nu, -18*nu+6, 24-8*nu , -6*nu-6 , 8*nu    , 18*nu-6 , -12+4*nu, 6*nu+6  ];
        [18*nu-6 , 8*nu    , -6*nu-6 , 24-8*nu , -18*nu+6, -12-4*nu, 6*nu+6  , -12+4*nu];
        [-12+4*nu, -6*nu-6 , 8*nu    , -18*nu+6, 24-8*nu , 6*nu+6  , -12-4*nu, 18*nu-6 ];
        [-6*nu-6 , -12+4*nu, 18*nu-6 , -12-4*nu, 6*nu+6  , 24-8*nu , -18*nu+6, 8*nu    ];
        [8*nu    , 18*nu-6 , -12+4*nu, 6*nu+6  , -12-4*nu, -18*nu+6, 24-8*nu , -6*nu-6 ];
        [-18*nu+6, -12-4*nu, 6*nu+6  , -12+4*nu, 18*nu-6 , 8*nu    , -6*nu-6 , 24-8*nu ]...
        ];
    elseif const.Nod_dof == 1 % SH (out-of-plane shear)
        k_ele = E*t/12/(1 + nu)*...
            [4, -1, -2, -1; -1, 4, -1, -2; -2, -1, 4, -1; -1, -2, -1, 4]; 
    elseif const.Nod_dof == 3 % (PSV + SH)
        fprintf('Case not coded yet.')
        return
    else
        fprintf('Number of degrees of freedom per node can only be 1, 2, or 3.')
        return
    end
end
