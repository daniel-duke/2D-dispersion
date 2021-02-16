clear; close all;
N_freq = 500;
N_contour_points = 40;
isSubsample = false;
N_struct_convert = 10;
min_freq_cutoff = 5;
freq_step = 5;
data_full_path = 'C:\Users\alex\OneDrive - California Institute of Technology\Documents\Graduate\Research\2D-dispersion-GPR\OUTPUT\N_struct1024 output 10-Dec-2020 14-02-57\DATA N_struct1024 RNG_offset0 10-Dec-2020 14-02-57.mat';
load(data_full_path);
% filename = trim

ELASTIC_MODULUS_DATA = CONSTITUTIVE_DATA('modulus');
DENSITY_DATA = CONSTITUTIVE_DATA('density');
POISSON_DATA = CONSTITUTIVE_DATA('poisson');

[N_wv,N_eig,N_struct] = size(EIGENVALUE_DATA);

EIGENVALUE_DATA = reshape(EIGENVALUE_DATA,[sqrt(N_wv) sqrt(N_wv) N_eig N_struct]);

N_idxs = length(size(EIGENVALUE_DATA));
% A = zeros(N_struct,N_idxs + N_eig + 2);
A = [];

w = waitbar(0,'Converting raw data to isocontour data');
waitcounter = 0;

x = linspace(-pi,pi,sqrt(N_wv));
y = linspace(0,pi,sqrt(N_wv));

for struct_idx = 1:N_struct_convert
    min_freq = min(EIGENVALUE_DATA(:,:,:,struct_idx),[],'all'); min_freq = max(min_freq,min_freq_cutoff);
    max_freq = max(EIGENVALUE_DATA(:,:,:,struct_idx),[],'all');
%     freqs = linspace(min_freq,max_freq,N_freq);
    freqs = min_freq:freq_step:max_freq;
    
    path_ids = zeros(length(freqs),1);
    
    for eig_idx = 1:N_eig
        [wv_idx1,wv_idx2,fr] = find(EIGENVALUE_DATA(:,:,eig_idx,struct_idx));
        temp = sparse(wv_idx1,wv_idx2,fr);
        Z = full(temp);
        for freq_idx = 1:length(freqs)
            freq = freqs(freq_idx);
            M = contourc(x,y,Z,[freq freq]); % The syntax for contour at single height is to repeat that height in a 1x2 vector
            if ~isempty(M)
                out = get_paths_from_contour_matrix(M);
                for path_idx = 1:out.N_paths
                    path_ids(freq_idx) = path_ids(freq_idx) + 1;
                    P = out.paths{path_idx};
                    if isSubsample
                        N_points = min(N_contour_points,size(P,2)); % Avoid performing kmeans on too few points
                        [idx,C] = kmeans(P',N_points);
                        wv_x = C(:,1); wv_y = C(:,2);
                    else
                        N_points = size(P,2);
                        wv_x = P(1,:)'; wv_y = P(2,:)';
                    end
                    if max(wv_x) > pi || max(wv_y) > pi
                        error('out of bounds!')
                    end
                    A = [A ; struct_idx*ones(N_points,1) freq*ones(N_points,1) path_ids(freq_idx)*ones(N_points,1) (1:N_points)' wv_x wv_y eig_idx*ones(N_points,1)];
                end
            end
        end
        waitcounter = waitcounter + 1;
        waitbar(waitcounter/(N_struct_convert*N_eig),w)
    end
end

close(w);

T = array2table(A,'VariableNames',{'struct_idx','frequency','path_id','sequence_id','wavevector_x','wavevector_y','eig_idx'});

writetable(T,'table.txt','Delimiter','tab')

