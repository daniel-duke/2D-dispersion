classdef DispersionDataset
    properties
        dispersion_computation_parameters = DispersionComputationParameters;
        design_variable = DesignVariable;
        N_wavevector
        N_band
        N_dispersion_relation
        isWavevectorArray % breaks the naming convention rules...
        wavevector_array_size(1,2)
        wavevector_array_shape char % this can be used someday for cases where the array is not rectangular
        frequency
        wavevector
        eigenvector
    end
    methods(Static)
        function axes
            line_break = repmat('=',1,20);
            disp(line_break)
            disp('frequency:')
            disp('wavevector, band, dispersion relation')
            disp(line_break)
            disp('wavevector:')
            disp('wavevector, wavevector component')
            disp(line_break)
            disp('eigenvector:')
            disp('degree of freedom, wavevector, band, dispersion relation')
            disp(line_break)
        end
    end
    methods
        function obj = DispersionDataset(N_wavevector,N_band,N_dispersion_relation)
            obj.N_wavevector = N_wavevector;
            obj.N_band = N_band;
            obj.N_dispersion_relation = N_dispersion_relation;
            obj.frequency = zeros(N_wavevector,N_band,N_dispersion_relation);
            obj.wavevector = []; % zeros(N_wavevector,2);
            %             obj.eigenvector = (only want to save eigenvector sometimes)
        end
        function obj = import_dispersion_computation_parameters(obj,dispersion_computation)
            if nargout == 0
                error('nargout == 0')
            end
            obj.dispersion_computation_parameters = dispersion_computation.dispersion_computation_parameters;
        end
        function obj = import_dispersion_computation_design_variable(obj,dispersion_computation,dispersion_relation_index)
            if nargout == 0
                error('nargout == 0')
            end
            obj.design_variable(dispersion_relation_index) = dispersion_computation.design_variable;
        end
        function obj = import_dispersion_computation_wavevector(obj,dispersion_computation)
            if nargout == 0
                error('nargout == 0')
            end
            obj.wavevector = dispersion_computation.wavevector;
            obj.wavevector_array_size = dispersion_computation.dispersion_computation_parameters.wavevector_array_size;
        end
        function obj = import_dispersion_computation_frequency(obj,dispersion_computation,dispersion_relation_index)
            if nargout == 0
                error('nargout == 0')
            end
            obj.frequency(:,:,dispersion_relation_index) = dispersion_computation.frequency;
        end
        function obj = import_dispersion_computation_eigenvector(obj,dispersion_computation,dispersion_relation_index)
            if nargout == 0
                error('nargout == 0')
            end
            obj.eigenvector(:,:,:,dispersion_relation_index) = dispersion_computation.eigenvector;
        end
        function obj = import_dispersion_computation(obj,dispersion_computation,dispersion_relation_index)
            if nargout == 0
                error('nargout == 0')
            end
            if isempty(obj.dispersion_computation_parameters)
                obj = import_dispersion_computation_parameters(obj,dispersion_computation);
            end
            if isempty(obj.wavevector)
                obj = import_dispersion_computation_wavevector(obj,dispersion_computation);
            end
            obj = import_dispersion_computation_design_variable(obj,dispersion_computation,dispersion_relation_index);
            obj = import_dispersion_computation_frequency(obj,dispersion_computation,dispersion_relation_index);
            if dispersion_computation.dispersion_computation_parameters.isSaveEigenvector
                if isempty(obj.eigenvector)
                    warning('eigenvector array not initialized')
                end
                obj = import_dispersion_computation_eigenvector(obj,dispersion_computation,dispersion_relation_index);
            end
        end
        function obj = initialize_eigenvector_array(obj,dispersion_computation)
            N_dof = size(dispersion_computation.eigenvector,1);
            obj.eigenvector = zeros(N_dof,obj.N_wavevector,obj.N_band,obj.N_dispersion_relation);
        end
        function save(dispersion_dataset,filename)
            if ~strcmp(filename(end-3:end),'.mat')
                filename = [filename '.mat'];
            end
            save(filename,'dispersion_dataset','-mat','-v7.3')
        end
    end
end