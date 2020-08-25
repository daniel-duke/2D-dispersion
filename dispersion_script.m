clear; close all;
const.a = 1; % [m]
const.N_ele = 80;
const.N_pix = 1;
const.N_k = 16;
const.N_eig = 8;
const.isUseGPU = false;

%% Dispersive cell
% const.design(:,:,1) = zeros(const.N_pix); % the first pane is E
% idxs = (const.N_pix/4 + 1):(3*const.N_pix/4);
% const.design(idxs,idxs,1) = 1;
% const.design(:,:,2) = const.design(:,:,1); % the second pane is rho
% const.design(:,:,3) = .6*ones(const.N_pix); % the third pane is poisson's ratio

%% Homogeneous cell
const.design(:,:,1) = ones(const.N_pix); % the first pane is E
const.design(:,:,2) = const.design(:,:,1); % the second pane is rho
const.design(:,:,3) = .6*ones(const.N_pix); % the third pane is poisson's ratio

const.E_min = 2e9;
const.E_max = 200e9;
const.rho_min = 1e3;
const.rho_max = 8e3;
const.poisson_min = 0;
const.poisson_max = .5;
const.t = 1;
const.sigma_eig = 1;

%% Plot the design
plot_design(const.design);

%% Solve the dispersion problem
[wn,fr,ev,wv] = dispersion(const);

%% Plot the discretized Irreducible Brillouin Zone
figure2();
hold on
% axis([-pi/const.a pi/const.a -pi/const.a pi/const.a])
scatter(wv(1,:),wv(2,:),[],[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerFaceAlpha',.5)
daspect([1 1 1])
for i = 1:size(wv,2)
    text(wv(1,i)+.05,wv(2,i)+.05,num2str(i));
end
hold off


%% Plot the dispersion relation
plot_dispersion(wn,fr);

%% Plot the modes
k_idx = 1;
eig_idx = 8;
eig_vecs = squeeze(ev(:,k_idx,:));
wavevector = wv(:,k_idx);
plot_mode(eig_vecs,eig_idx,wavevector,const)
