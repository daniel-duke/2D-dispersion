classdef design_generator
    properties
        kernel_name
        kernel_params
        symmetry
        N_pix
        N_value
        isBoringPoisson
    end
    methods
        function obj = design_generator()
            obj.symmetry = 'none';
            obj.isBoringPoisson = true;
        end
        function design = generate(obj,design_number)
            obj = obj.prepare();
            % Expand if only one design number is specified
            if numel(design_number) == 1
                design_number = repmat(design_number,3,1);
            end
            design = design_variable;
            prop_names = {'E','rho','nu'};
            for i = 1:3
                rng(design_number(i),'twister');
                design.(prop_names{i}) = kernel_prop(obj.kernel_name{i},obj.N_pix,obj.kernel_params{i});
            end
            if obj.isBoringPoisson
                design.nu = 0.6*ones(obj.N_pix);
            end
        end
        function obj = prepare(obj)
            obj = obj.expand_property_information;
        end
        function obj = expand_property_information(obj)
            % kernel_name
            if isa(obj.kernel_name,'char')
                temp = obj.kernel_name;
                obj.kernel_name = cell(1,3);
                for i = 1:3
                    obj.kernel_name{i} = temp;
                end
            elseif isa(obj.kernel_name,'cell')
                if numel(obj.kernel_name) == 1
                    for i = 2:3
                        obj.kernel_name{i} = obj.kernel_name{1};
                    end
                end
            end
            % kernel_parameters
            if numel(obj.kernel_params) == 1
                temp = obj.kernel_params;
                obj.kernel_params = cell(1,3);
                [obj.kernel_params{:}] = deal(temp);
            end
        end
    end
end