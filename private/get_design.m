function design = get_design(design_parameters)
    design = zeros(design_parameters.N_pix);
    for prop_idx = 1:3
        design(:,:,prop_idx) = get_prop(design_parameters,prop_idx);
    end
end
