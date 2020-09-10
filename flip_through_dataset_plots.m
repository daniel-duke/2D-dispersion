clear; close all;
filename = "C:\Users\alex\OneDrive - California Institute of Technology\Documents\Graduate\Research\2D-dispersion\OUTPUT\dataset400 Gamma_to_X output 02-Sep-2020 17-34-03\DATA N_struct400 02-Sep-2020 17-34-03.mat";
load(filename,'EIGENVALUE_DATA','WAVEVECTOR_DATA','CONSTITUTIVE_DATA');

[N_struct,N_eig,N_k] = size(EIGENVALUE_DATA);

for struct_idx = 1:N_struct
    figure2();
    hold on
    for eig_idx = 1:N_eig
        line(squeeze(WAVEVECTOR_DATA(struct_idx,1,:)),squeeze(EIGENVALUE_DATA(struct_idx,eig_idx,:)))
    end
    title(['structure ' num2str(struct_idx)])
    xlabel('k_x')
    ylabel('\omega')
    pause
end


