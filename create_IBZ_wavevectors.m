function wavevectors = create_IBZ_wavevectors(N_k,a)
    [X,Y] = meshgrid(linspace(0,pi/a,N_k),linspace(0,pi/a,N_k));
    k_x = X(triu(true(size(X)))); k_y = Y(triu(true(size(Y))));
    wavevectors = cat(2,k_x,k_y)';
end