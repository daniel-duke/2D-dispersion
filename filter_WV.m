function [wv_comp_filt,fr_comp_filt] = filter_WV(wv_comp,fr_comp,fr)
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
ep_w = (fr(2)-fr(1))*1.5;
for sco = 1:3 % three stages of the IBZ contour
    wv = wv_comp{sco};
    f = fr_comp{sco};
    discard_ind = [];
    for wco = 2:length(wv)
        if abs(real(wv(wco))-real(wv(wco-1)))>ep_k || abs(f(wco)-f(wco-1))>ep_w
            discard_ind = [discard_ind wco];
        end
    end
    wv(discard_ind) = [];
    f(discard_ind) = [];
    wv_comp_filt{sco} = wv;
    fr_comp_filt{sco} = f;
end
end