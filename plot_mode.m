function plot_mode(eig_vecs,eig_idx,wavevector,const)
    original_nodal_locations = const.a*(0:const.N_ele*const.N_pix)./(const.N_ele*const.N_pix);
    [X,Y] = meshgrid(original_nodal_locations,original_nodal_locations);
    eig_vec = eig_vecs(eig_idx,:);
    U = eig_vec(1:2:end);
    U_mat = reshape(U,const.N_ele*const.N_pix,const.N_ele*const.N_pix);
    U_full = fill_with_bloch(U_mat,const);
    V = eig_vec(2:2:end);
    V_mat = reshape(V,const.N_ele*const.N_pix,const.N_ele*const.N_pix);
    V_full = fill_with_bloch(V_mat,const);
    
    figure();
    p1 = plot(X,Y,'k.');
    axis([-.1 1.1 -.1 1.1]);
    hold on
    for t = 1:100
        c = sin(t/10);
        p2 = plot(real(X + c*U_full), real(Y + c*V_full),'r.');
        pause(.1)
        delete(p2);
    end
    
    function U_full = fill_with_bloch(U_mat,const)
        U_full = zeros(const.N_ele*const.N_pix + 1);
        U_full(1:(end-1),1:(end-1)) = U_mat;
        r = [const.a ; 0];
        U_full(1:(end-1),end) = U_full(1:(end-1),1)*exp(1i*dot(wavevector,r));
        r = [0 ; -const.a];
        U_full(end,:) = U_full(1,:)*exp(1i*dot(wavevector,r));
    end
end