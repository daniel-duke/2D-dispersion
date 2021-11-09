function [wv_comp_filt,fr_comp_filt] = filter_Complex_WV(wv_comp,fr_comp,fr)
% Purpose: Filter out the spurious unphysical eigenvalues from the complex
% wave vectors
% -------------------------------------------------------------------
% Input:
% wv_comp,fr_comp,fr: complex eigenvalues and associated frequencies, also
% total frequencies
% -------------------------------------------------------------------
% Output:
% wv_comp,fr_comp: filtered complex eigenvalues and corresponding
% frequencies
% -------------------------------------------------------------------

% threshold
ep_k = 0.01;
ep_f = (fr(2)-fr(1))*2;
ep = 0.05;

for sco = 1:3 % three stages of the IBZ contour
    wv = wv_comp{sco};
    f = fr_comp{sco};
    discard_ind = [];
    ind = 1:length(wv);
    for wco = 2:length(wv)
        % frequency window
        f_win=find(abs(f(:)-f(wco))<20); 
        f_dist = abs(f(wco)-f(f_win));
        wv_dist = abs(real(wv(wco))-real(wv(f_win)));
        euclid_dist = sqrt(f_dist.^2 + wv_dist.^2);
        Id = find(f_win(:)==wco);
        euclid_dist(Id) = 100; wv_dist(Id) = 100;  f_dist(Id) = 100; 
%         if f(wco)== 701.001
%             keyboard
%         end
        if any(f_dist<ep_f & wv_dist>ep_k) || min(euclid_dist)>ep 
            discard_ind = [discard_ind wco];
        end
    end
    wv(discard_ind) = [];
    f(discard_ind) = [];
    wv_comp_filt{sco} = wv;
    fr_comp_filt{sco} = f;
end
end
