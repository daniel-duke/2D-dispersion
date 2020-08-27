clear; close all;
const.a = 1; % [m]
const.N_ele = 4;
const.N_pix = 20;
const.N_k = 16;
const.N_eig = 20;
const.isUseGPU = false;
const.isUseUltraVec = true;
const.isUseFastT = true;

%% My cell
upix = [1 0 1 0 0 1 1 0 0 0 1 1 1 0 1 0 0 1 1 1 1 1 0 0 1 1 0 1 0 0 1 1 1 1 0 0 1 0 1 1 1 0 1 0 0 0 0 1 1 0 1 1 1 1 0];
const = get_design_original_setting(upix2mat(upix), const);

const.t = 10;
const.sigma_eig = 1;

%% Plot the design
plot_design(const.design);

%% Solve the dispersion problem
[wn,fr,ev,wv] = dispersion(const);

%% Plot the discretized Irreducible Brillouin Zone
% figure();
% hold on
% % axis([-pi/const.a pi/const.a -pi/const.a pi/const.a])
% scatter(wv(1,:),wv(2,:),[],[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerFaceAlpha',.5)
% daspect([1 1 1])
% for i = 1:size(wv,2)
%     text(wv(1,i)+.05,wv(2,i)+.05,num2str(i));
% end
% hold off


%% Plot the dispersion relation
plot_dispersion(wn,fr);

%% Plot the modes
k_idx = 1;
eig_idx = 6;
eig_vecs = squeeze(ev(:,k_idx,:));
wavevector = wv(:,k_idx);
plot_mode(eig_vecs,eig_idx,wavevector,const)