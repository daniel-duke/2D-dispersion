% Script to plot computation time for complex and standard dispersiion
% curves

n = [0.5, 5, 20, 40].*2;
t_norm = [0.121961, 0.323212, 1.490187, 5.007938];
t_comp = [0.449704,9.963562, 91.373, 1578.210517];


figure,
loglog(n,t_norm,n,t_comp,'linewidth',1.5)
% hold on 
% loglog(n,n.^2, n,n.^3, n, n.^4)
grid on 

xlabel('Matrix size, $n$','fontsize',15,'interpreter','latex')
ylabel('Computation time, s','fontsize',15,'interpreter','latex')
legend('Standard dispersion \omega (\kappa)', ...
    'Complex dispersion \kappa (\omega)','fontsize',12)
