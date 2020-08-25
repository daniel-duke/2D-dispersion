clear; close all;
const.a = 1; % [m]
const.N_ele = 2;
const.N_pix = 1;
const.N_k = 50;
const.N_eig = 2;

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


dispersion(const)