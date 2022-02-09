classdef DesignVariableInterpreter
    properties
        design_variable_scaling; % Should be 'linear', 'log', or 'explicit'
        lattice_length % could be replaced by lattice_parameters in future, which would store 3 lattice lengths and 3 lattice angles in 3D. Or 2 lengths and one angle in 2D.
        thickness
        E_min
        E_max
        rho_min
        rho_max
        nu_min
        nu_max
    end
end
