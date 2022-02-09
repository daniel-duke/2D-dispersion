classdef DispersionDataset
    properties
        design_variables = DesignVariable;
        N_dispersion
        dispersion_relation = DispersionRelation;
        frequency
        wavevector
        eigenvector
    end
    methods(Static)
        function axes
            disp('wavevector_index, band_index, dispersion_relation_index')
        end
    end
end