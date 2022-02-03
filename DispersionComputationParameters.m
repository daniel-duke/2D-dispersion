classdef DispersionComputationParameters
    properties
        N_wv;
        N_eig;
        N_ele;
        N_pix;
        sigma_eig;
        isUseParallel;
        isUseImprovement;
        isSaveEigenvectors;
        isUseGPU;
    end
    methods
        function obj = DispersionComputationParameters()
            obj.isUseParallel = true;
            obj.isUseImprovement = true;
            obj.isSaveEigenvectors = false;
            obj.isUseGPU = false;
        end
    end
end