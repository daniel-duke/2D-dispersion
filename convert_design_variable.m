function converted_design_variable = convert_design_variable(design_variable,initial_format,target_format,design_variable_interpreter)
    % initial_format and target_format can be 'linear','log','explicit'
    warning('ensure design variable conversion is happening correctly')

    if strcmp(initial_format,target_format)
        converted_design_variable = design_variable;
        return
    end

    %     if strcmp(initial_format,'linear')
    %         explicit_design = cat(3,E_min + (E_max - E_min)*design(:,:,1), rho_min + (rho_max - rho_min)*design(:,:,2), poisson_min + (poisson_max - poisson_min)*design(:,:,3));
    %     elseif strcmp(initial_format,'log')
    %         explicit_design = cat(3,exp(design(:,:,1:2)),poisson_min + (poisson_max - poisson_min)*design(:,:,3));
    %     elseif strcmp(initial_format,'explicit')
    %         explicit_design = design;
    %     end
    %
    %     if strcmp(target_format,'linear')
    %         converted_design = cat(3,(explicit_design(:,:,1) - E_min)/(E_max - E_min),(explicit_design(:,:,2) - rho_min)/(rho_max - rho_min),(explicit_design(:,:,3 - poisson_min))/(poisson_max - poisson_min));
    %     elseif strcmp(target_format,'log')
    %         converted_design = cat(3,log(explicit_design(:,:,1:2)),(explicit_design(:,:,3 - poisson_min))/(poisson_max - poisson_min));
    %     end
    
    prop_names = {'E','rho','nu'};
    for prop_idx = 1:3
        prop_name = prop_names{prop_idx};
        % Convert to explicit property values
        switch initial_format
            case 'linear'
                prop_min = design_variable_interpreter.([prop_name '_min']);
                prop_max = design_variable_interpreter.([prop_name '_max']);
                prop_var = design_variable.(prop_name);
                explicit_design_variable.(prop_name) = prop_min + (prop_max - prop_min)*prop_var;
            case 'log'
                explicit_design_variable.(prop_name) = exp(design_variable.(prop_name));
            case 'explicit'
                explicit_design_variable.(prop_name) = design_variable.(prop_name);
            otherwise
                error('initial_format not recognized')
        end

        % Convert explicit property values to the proper representation
        switch target_format
            case 'linear'
                prop_min = design_variable_interpreter.([prop_name '_min']);
                prop_max = design_variable_interpreter.([prop_name '_max']);
                explicit_prop_var = explicit_design_variable.(prop_name);
                converted_design_variable.(prop_name) = (explicit_prop_var - prop_min)/(prop_max - prop_min);
            case 'log'
                converted_design_variable.(prop_name) = log(explicit_design_variable.(prop_name));
            case 'explicit'
                converted_design_variable.(prop_name) = explicit_design_variable.(prop_name);
            otherwise
                error('target_format not recognized')
        end
    end