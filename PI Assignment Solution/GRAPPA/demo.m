%GRAPPA G-factor Demo
%   Script that Demos GRAPPA G-factor Calculation
%% ------------------------------------------------------------------------
% Setting up DATA
%--------------------------------------------------------------------------
load('Cardiac_SA.mat');
ksize = [5, 4];                             % GRAPPA kernel-window-size
[sx,sy,Nc,Nimg] = size(DATA);               % dim of data

% ---- Finding the noise covariance matrix ----- %
sig = cov(noise);
Nacq = sum(sum(DATA(:,:,1)~=0));

%% ------------------------------------------------------------------------
% GRAPPA Reconstruction
%--------------------------------------------------------------------------
tic;
fprintf('Image Reconstruction\n');
[im, res, w] = grappa_tc_2(DATA, ksize, arcACS);
tic;
% generate senstivity maps to do sense R1 reconstruction
smap = senseMap(im,7); 

%% ------------------------------------------------------------------------
% GRAPPA g-factor and SNR maps
%--------------------------------------------------------------------------
tic;
fprintf('SNR and G-factor Calculation\n');

% Obtain GRAPPA weights in Image Domain
wim = grappa_im_weight(w, Nc, R, ksize, [sx sy], Nacq);
% Calculate G-factor and Scale SNR maps
[g, gsos, ~,~, im_b1] = grappa_gfact(wim, sig, im, smap, 1);


%% ------------------------------------------------------------------------
% Plotting
%--------------------------------------------------------------------------
figure(1); imagesc(abs(im(:,:))); caxis([0 15]); colormap gray; axis image off;
figure(2); imagesc(g(:,:)); caxis([.8 1.5]); axis image off; 

figure(3); imagesc(im_b1); caxis([0 15]); colormap gray; axis image off;
figure(4); imagesc(gsos); colorbar; caxis([.8 1.5]); axis image off;

