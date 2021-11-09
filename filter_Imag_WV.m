function [wv_imag_filt,fr_imag_filt] = filter_Imag_WV(wv_imag,fr_imag,fr)
% Purpose: Filter out the spurious unphysical eigenvalues from the real
% wave vectors
% -------------------------------------------------------------------
% Input:
% wv_imag,fr_imag,fr: pure imaginary eigenvalues and associated frequencies, also
% total frequencies
% -------------------------------------------------------------------
% Output:
% wv_imag_filt,fr_imag_filt: filtered imaginary eigenvalues and corresponding
% frequencies
% -------------------------------------------------------------------

% threshold
ep_k = 3;
ep_f = (fr(2)-fr(1))*15;

for sco = 1:3 % three stages of the IBZ contour
    wv = wv_imag{sco};
    f = fr_imag{sco};
    discard_ind = [];
    for wco = 2:length(wv)
        if abs(wv(wco)-wv(wco-1))>ep_k || abs(f(wco)-f(wco-1))>ep_f
            discard_ind = [discard_ind wco];
        end
    end
    wv(discard_ind) = [];
    f(discard_ind) = [];
    wv_imag_filt{sco} = wv;
    fr_imag_filt{sco} = f;
end
end