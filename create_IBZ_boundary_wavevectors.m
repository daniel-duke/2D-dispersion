function wavevectors = create_IBZ_boundary_wavevectors(N_k,a)
    wavevectors = linspaceNDim([0;0],[pi/a; 0],N_k);
    wavevectors = [wavevectors(:,1:(end-1)) linspaceNDim([pi/a; 0],[pi/a; pi/a],N_k)];
    wavevectors = [wavevectors(:,1:(end-1)) linspaceNDim([pi/a; pi/a],[0; 0],N_k)];
    wavevectors = wavevectors(:,1:(end-1));
end