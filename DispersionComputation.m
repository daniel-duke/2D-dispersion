classdef DispersionComputation
    properties
        dispersion_computation_parameters = DispersionComputationParameters;
        design_variable = DesignVariable;
        design_variable_interpreter = DesignVariableInterpreter;
        frequency
        wavevector
        eigenvector
    end
    methods
        function dispersion_computation = run(dispersion_computation)
            if nargout == 0
                error('nargout == 0')
            end
            dispersion_computation = dispersion3(dispersion_computation);
        end
    end
end