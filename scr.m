clear; close all;
%% Step 1
% For numerical gradients
Kr1 = Kr/max(Kr,[],'all');
Mr1 = Mr/max(Mr,[],'all');

% Compute analytical gradient
dTf = full(dTdwavevector);
Tf = full(T);
Kf = full(K)/max(K,[],'all');
Mf = full(M)/max(M,[],'all');

dM1 = pagemtimes(dTf,'ctranspose',Mf*Tf,'none') + pagemtimes(Tf'*Mf,dTf);
dM2 = 2*real(pagemtimes(Tf'*Mf,dTf));

M_diff = max(dM1-dM2,[],'all');

dK1 = pagemtimes(dTf,'ctranspose',Kf*Tf,'none') + pagemtimes(Tf'*Kf,dTf);
dK2 = 2*real(pagemtimes(Tf'*Kf,dTf));

K_diff = max(dK1-dK2,[],'all');

%% Step 2
% For numerical gradients
Kr2 = Kr/max(Kr,[],'all');
Mr2 = Mr/max(Mr,[],'all');

% Compute numerical gradients
dKn = (Kr2 - Kr1)/(1e-8);
dMn = (Mr2 - Mr1)/(1e-8);

%% Derivative with respect to SECOND wavevector component

figure2()
imagesc(abs(dKn))
title('numerical')
colorbar

figure2()
imagesc(abs(dK1(:,:,2)))
title('1')
colorbar

figure2()
imagesc(abs(dK2(:,:,2)))
title('2')
colorbar

figure2()
imagesc(abs(dK1(:,:,2) - dKn))
title('1 minus numerical')
colorbar

%% Derivative with respect to FIRST wavevector component
figure2()
imagesc(abs(dKn))
title('numerical')
colorbar

figure2()
imagesc(abs(dK1(:,:,1)))
title('1')
colorbar

figure2()
imagesc(abs(dK2(:,:,1)))
title('2')
colorbar

figure2()
imagesc(abs(dK1(:,:,1) - dKn))
title('1 minus numerical')
colorbar
    