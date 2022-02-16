classdef DispersionComputationParameters
    properties
        wavevector_array_size;
        N_wavevector;
        N_band;
        N_element;
        N_pixel;
        sigma_eig = 1;
        isUseParallel(1,1) logical = true;
        isUseImprovement(1,1) logical  = true;
        isSaveEigenvector(1,1) logical  = false;
        isUseGPU(1,1) logical = false;
    end
end