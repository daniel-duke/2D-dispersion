classdef DispersionComputation
    properties
        dispersion_computation_parameters = DispersionComputationParameters;
        design_variable = DesignVariable;
        design_variable_interpreter = DesignVariableInterpreter;
        frequency % should freq, wavevector and eigenvector be embedded in another object called DispersionRelation? or FrequencyBand which is a property of DispersionRelation?
        wavevector
        eigenvector
    end
    methods
        function dispersion_computation = run(dispersion_computation)
            if nargout == 0
                error('nargout == 0')
            end
            dispersion_computation = dispersion(dispersion_computation);
        end
    end
    methods(Static)
        function axes
            line_separator = repmat('=',1,20);
            disp(line_separator)
            disp('frequency:')
            disp('wavevector, band')
            disp(line_separator)
            disp('wavevector:')
            disp('wavevector, wavevector_component')
            disp(line_separator)
            disp('eigenvector:')
            disp('degree of freedom, wavevector, band')
            disp(line_separator)
        end
    end
end