function [wv_imag_0,fr_imag_0,wv_imag_pi,fr_imag_pi,wv_real,fr_real,...
    wv_comp,fr_comp] = extract_ReImComplex_WV(wv_MG,wv_GX,wv_XM,fr)
% Purpose: Extract the pure real, pure imaginary, and complex components of
% the wave vector in complex dispersion, also filter out the spurious
% e-values
% -------------------------------------------------------------------
% Input: 
% wv_MG,wv_GX,wv_XM,fr: eigenvectors and associated frequencies
% -------------------------------------------------------------------
% Output: 
% wv_imag_0,fr_imag_0,wv_imag_pi,fr_imag_pi,wv_real,fr_real,...
%    wv_comp,fr_comp: pure imaginary, pure real and complex eigenvectors as
%    well as their associated frequency values
% -------------------------------------------------------------------




% Wave vector stages are M to Gamma, Gamma to X, X to M
    stage = [1,2,3];
    wv_stag = {wv_MG,wv_GX,wv_XM};
    es = 0.005;
    
    for sco = 1:length(stage)
        wv = wv_stag{sco};
        rs_wv = reshape(wv,1,[]);
        rs_fr = reshape(repmat(fr,size(wv,1),1),1,[]);
        % pure imaginary waves at k = 0
        I0 = find(abs(real(rs_wv))<es & imag(rs_wv)>0 & imag(rs_wv)~=inf);
        % pure imaginary waves at k = pi
        I1 = find(abs(abs(real(rs_wv))-pi)<es & imag(rs_wv)>0 & imag(rs_wv)~=inf);
        % pure real waves
        I2 = find(abs(imag(rs_wv))<es & real(rs_wv)>0 & real(rs_wv)~=inf);
        % Complex waves
        I3 = find(imag(rs_wv)>es & real(rs_wv)>es & abs(real(rs_wv)-pi)>es...
             & imag(rs_wv)<3*pi  & real(rs_wv)~=inf); % just a way to filter complex spurious modes
         % & imag(rs_wv)<2*pi  & real(rs_wv)~=inf);
        
        % Assigning real, imag, complex wavevectors and frequencies
        wv_imag_0{sco} = imag(rs_wv(I0));
        fr_imag_0{sco} = rs_fr(I0);
        wv_imag_pi{sco} = imag(rs_wv(I1));
        fr_imag_pi{sco} = rs_fr(I1);
        wv_real{sco} = real(rs_wv(I2));
        fr_real{sco}= rs_fr(I2);
        wv_comp{sco} = rs_wv(I3);
        fr_comp{sco} = rs_fr(I3);
    end
