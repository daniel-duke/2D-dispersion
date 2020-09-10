clear; close all; %delete(findall(0));
const.a = 1; % [m]
const.N_ele = 50;
const.N_pix = 4;
const.N_k = 30;
const.N_eig = 8;
const.isUseGPU = false;
const.isUseImprovement = false;
const.isUseParallel = true;

const.wavevectors = create_wavevector_array(const.N_k,const.a);
% const.wavevectors = [0, 1.309, pi/2, pi/const.a;
%                      0, 0,     0,    0        ];

%% Dispersive cell - Tetragonal
% const.design(:,:,1) = zeros(const.N_pix); % the first pane is E
% idxs = (const.N_pix/4 + 1):(3*const.N_pix/4);
% const.design(idxs,idxs,1) = 1;
% const.design(:,:,2) = const.design(:,:,1); % the second pane is rho
% const.design(:,:,3) = .6*ones(const.N_pix); % the third pane is poisson's ratio

%% Dispersive cell - Orthotropic
% const.design(:,:,1) = zeros(const.N_pix); % the first pane is E
% idxs = (const.N_pix/4 + 1):(3*const.N_pix/4);
% const.design(:,idxs,1) = 1;
% const.design(:,:,2) = const.design(:,:,1); % the second pane is rho
% const.design(:,:,3) = .6*ones(const.N_pix); % the third pane is poisson's ratio

%% Homogeneous cell
% const.design(:,:,1) = ones(const.N_pix); % the first pane is E
% const.design(:,:,2) = const.design(:,:,1); % the second pane is rho
% const.design(:,:,3) = .6*ones(const.N_pix); % the third pane is poisson's ratio

%% Counting cell
% const.design(:,:,1) = reshape(1:(const.N_pix*const.N_pix),const.N_pix,const.N_pix)./(const.N_pix*const.N_pix);
% const.design(:,:,2) = const.design(:,:,1);
% const.design(:,:,3) = .6*ones(const.N_pix);

%% Random cell
rng(1)
const.design(:,:,1) = round(rand(const.N_pix));
const.design(:,:,2) = const.design(:,:,1);
const.design(:,:,3) = .6*ones(const.N_pix);

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
[wv,fr,ev] = dispersion(const,const.wavevectors);
fr(:,end + 1) = fr(:,1);
ev(:,end + 1,:) = ev(:,1,:);
[ev,theta] = align_eigenvectors(ev,const);
wn = linspace(0,3,size(const.wavevectors,2) + 1);
wn = repmat(wn,const.N_eig,1);

%% Plot the discretized Irreducible Brillouin Zone
plot_wavevectors(wv);


%% Plot the dispersion relation
figure2();
plot_dispersion(wn,fr);

%% Plot the modes
% k_idx = 2;
% eig_idx = 5;
% wavevector = wv(:,k_idx);
% plot_mode_ui(wv,fr,ev,const);
% plot_mode(wv,fr,ev,eig_idx,k_idx,'both',const)


isSaveOutput = true;
eig_idx = 5;
if isSaveOutput
    script_start_time = replace(char(datetime),':','-');
    output_folder = ['OUTPUT/output ' script_start_time];
    mkdir(output_folder);
    copyfile([mfilename('fullpath') '.m'],[output_folder '/' mfilename '.m']);
else
    output_folder = [];
    disp('WARNING: isSaveOutput is set to false. Output will not be saved.')
end

fig = figure2();
set(fig,'units','normalized');
set(fig,'outerposition',[0 0 1 1]);
VideoWriterObj = VideoWriter([output_folder '/mode_tracking_by_eig_idx ' script_start_time],'MPEG-4');
VideoWriterObj.FrameRate = 2;
open(VideoWriterObj);
for k_idx = 1:(size(wn,2) - 1)
    subplot(1,2,1)
    plot_dispersion(wn,fr);
    scatter(wn(1,k_idx),fr(eig_idx,k_idx),'ro');
    
    subplot(1,2,2)
    plot_mode(wv,fr,ev,eig_idx,k_idx,'stillui',0,const);
    
    writeVideo(VideoWriterObj,getframe(gcf))
end
close(VideoWriterObj);

figure2();
plot(theta(eig_idx,:));
xlabel('k_idx')
ylabel('\theta')