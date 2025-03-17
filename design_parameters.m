classdef design_parameters
    properties
        design_number
        design_style
        design_options
        N_pix
    end
    methods
        function obj = design_parameters(design_number)
            if nargin == 1
                obj.design_number = design_number;
                obj.design_style = 'kernel';
                obj.design_options = struct('sigma_f',1,'sigma_l',0.5,'symmetry_type','p4mm','N_value',inf);
                obj.N_pix = 32;
            end
        end

        function obj = prepare(obj)
            if isempty(obj.design_number)
                warning("no design number specified, set to 1")
                obj.design_number = 1;
            end
            if isempty(obj.design_style)
                error("no design style specified")
            end
            if isempty(obj.N_pix)
                error("number of pixels not specified")
            end
            obj = obj.expand_property_information;
        end

        function obj = expand_property_information(obj)
            % design_number
            if isscalar(obj.design_number)
                obj.design_number = repmat(obj.design_number,1,3);
            end
            % design_style
            if isa(obj.design_style,'char')
                obj.design_style = repmat({obj.design_style},1,3);
            elseif isa(obj.design_style,'cell')
                if isscalar(obj.design_style)
                    obj.design_style = repmat(obj.design_style,1,3);
                end
            end
            % design_options
            if isscalar(obj.design_options)
                obj.design_options = repmat({obj.design_options},1,3);
            end
        end

    end
end