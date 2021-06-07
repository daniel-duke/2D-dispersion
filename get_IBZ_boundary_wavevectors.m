function wavevectors = get_IBZ_boundary_wavevectors(N_k,a)
    if length(N_k) > 2
        N_k = N_k(1);
        warning('received N_k as a vector')
    end
    wavevectors = linspaceNDim([0;0],[pi/a; 0],N_k);
    wavevectors = [wavevectors(:,1:(end-1)) linspaceNDim([pi/a; 0],[pi/a; pi/a],N_k)];
    wavevectors = [wavevectors(:,1:(end-1)) linspaceNDim([pi/a; pi/a],[0; 0],N_k)];
    wavevectors = wavevectors(:,1:(end-1))';
end