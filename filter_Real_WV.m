function [wv_real_filt,fr_real_filt] = filter_Real_WV(wv_real,fr_real,fr)
% Purpose: Filter out the spurious unphysical eigenvalues from the real
% wave vectors
% -------------------------------------------------------------------
% Input:
% wv_real,fr_real,fr: pure real eigenvalues and associated frequencies, also
% total frequencies
% -------------------------------------------------------------------
% Output:
% wv_real_filt,fr_real_filt: filtered real eigenvalues and corresponding
% frequencies
% -------------------------------------------------------------------

% threshold
ep_k = 0.5;
ep_f = (fr(2)-fr(1))*3;
ep = 1.3;

for sco = 1:3 % three stages of the IBZ contour
    wv = wv_real{sco};
    f = fr_real{sco};
    discard_ind = [];
    for wco = 2:length(wv)
        ind = setdiff(1:length(wv),wco);
        f_dist = abs(f(wco)-f(ind));
        wv_dist = abs(real(wv(wco))-real(wv(ind)));
        euclid_dist = sqrt(f_dist.^2 + wv_dist.^2);
            
        if min(euclid_dist)>ep
            discard_ind = [discard_ind wco];
        end
    end
    wv(discard_ind) = [];
    f(discard_ind) = [];
    wv_real_filt{sco} = wv;
    fr_real_filt{sco} = f;
end
end