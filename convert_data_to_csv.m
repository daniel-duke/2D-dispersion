clear; close all;
load('C:\Users\alex\OneDrive - California Institute of Technology\Documents\Graduate\Research\2D-dispersion-GPR\OUTPUT\N_struct1024 output 10-Dec-2020 14-02-57\DATA N_struct1024 RNG_offset0 10-Dec-2020 14-02-57.mat');

ELASTIC_MODULUS_DATA = CONSTITUTIVE_DATA('modulus');
DENSITY_DATA = CONSTITUTIVE_DATA('density');
POISSON_DATA = CONSTITUTIVE_DATA('poisson');

[N_wv,N_eig,N_struct] = size(EIGENVALUE_DATA);

EIGENVALUE_DATA = reshape(EIGENVALUE_DATA,[sqrt(N_wv) sqrt(N_wv) N_eig N_struct]);

N_idxs = length(size(EIGENVALUE_DATA));
% A = zeros(N_struct,N_idxs + N_eig + 2);
A = [];

w = waitbar(0,'Converting EIGENVALUE\_DATA to sparse matrix format');
waitcounter = 0;

for struct_idx = 1:N_struct
    for eig_idx = 1:N_eig
        [wv_idx1,wv_idx2,fr] = find(EIGENVALUE_DATA(:,:,eig_idx,struct_idx));
        A = [A ; struct_idx*ones(size(wv_idx1)) eig_idx*ones(size(wv_idx1)) wv_idx1 wv_idx2 fr];
        
        waitcounter = waitcounter + 1;
        waitbar(waitcounter/(N_struct*N_eig),w)
    end
end

close(w);

T = array2table(A,'VariableNames',{'struct_idx','eig_idx','wavevector_idx1','wavevector_idx2','frequency'});

writetable(T,'table.txt','Delimiter','tab')
