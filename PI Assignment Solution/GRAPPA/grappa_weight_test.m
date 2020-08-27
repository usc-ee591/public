%Calibration data = data

%Script that performs Baseline PNoise recon
clear all; close all;
%%
%--------------------------------------------------------------------------
% Setting up DATA
%--------------------------------------------------------------------------
filename = '20-44-22_BASE_R2';
% filename = '20-35-01_BASE_R2';
noise = '20-57-14_BASE_R2';
% noise = '21-30-19_BASE_R1';
header = read_gehdr(filename);
R = header.rdb.user34;                      % SENSE acceleration factor
arcACS = header.rdb.user36;                 % Number of ACS lines
opt.dim=[1 2];                              % FFT dimension

[~, grappa, mask] = pfile2data(filename);   % Extract DATA from pfile
fact = max(abs(grappa(:)));
%DATA = grappa/fact+eps;
DATA = grappa.*mask;
DATA = permute(DATA, [2 1 3 4 5]);
%
[~, nk, mask] =  pfile2data(noise);         %Extract Noise from pfile
nk(:,sum(mask(:,:),2)>0,:,:,:) = [];

%%%%%%%%%%%%%%%%%%%    must choose symmetric kernel!!   %%%%%%%%%%%%%%%%%%%
ksize = [5, 4];                             % GRAPPA kernel-window-size
[sx,sy,Nc,Nimg,~] = size(DATA);             % dim of data
calib = crop(DATA(:,:,:,1),[sx,arcACS,Nc]); % calibration lines
[ny, nx, nc] = size(calib);                 % dim of calibration

%%
%--------------------------------------------------------------------------
% Generate GRAPPA weights
%--------------------------------------------------------------------------
DATA = DATA(:,:,:,1);
count = 0;

tic;
for y = 1:ny-(ksize(2)*R-1)
    for x = 1:nx-ksize(1)-1
        count = count+1;
        temp = circshift(calib, [y -x]);
        tempsrc = temp(1:1:ksize(1),1:R:R*ksize(2)-(R-1),:);
        temptg = temp(ceil(ksize(1)/2),R*floor(ksize(2)/2):R*floor(ksize(2)/2)+R-2,:);
        src(:,count) = tempsrc(:);
        stg(:,count) = temptg(:);
    end
end
w = stg*pinv(src);
toc;

%%
%--------------------------------------------------------------------------
% Regular GRAPPA (fill in Kspace)
%--------------------------------------------------------------------------
res = DATA;
tic;
for y = R*floor(ksize(2)/2):1:sy-(ksize(2)*R-1)
    for x = ceil(ksize(1)/2):sx-ksize(1)-1
        if sum(abs(DATA(x,y:y+R-2,:)),3) == 0
            tempsrc = DATA(x-ceil(ksize(1)/2)+1:1:x-ceil(ksize(1)/2)+ksize(1)-1+1,...
                y-R*floor(ksize(2)/2)+1:R:y+R*ksize(2)-(R-1)-R*floor(ksize(2)/2)+1,:);
            tempsrc = tempsrc(:);
            res(x,y:y+R-2,:) = reshape(w*tempsrc, [R-1 Nc]);
        end
    end
end
im1 = ifftnd(res, opt.dim,1);
im1sos = sos(im1);
toc;

% figure; imagesc(abs(DATA(:,:)), [0 0.01]); colormap gray; axis image;
% figure; imagesc(abs(res(:,:)), [0 0.01]); colormap gray; axis image;

h = figure; imagesc(abs(im1(:,:,3))); colormap gray; axis square; axis off;
set(h, 'Color', [0 0 0]);
h = figure; imagesc(angle(im1(:,:,3))); colormap jet; axis square; axis off;
set(h, 'Color', [0 0 0]);

h = figure; imagesc(im1sos); colormap gray; axis square; axis off;
set(h, 'Color', [0 0 0]);
%%
%--------------------------------------------------------------------------
% Image Domain GRAPPA
%--------------------------------------------------------------------------
tic;

w2 = reshape(w, [Nc*(R-1) ksize(1) ksize(2) Nc]);
w2 = permute(w2, [2 3 1 4]);

% wspace = zeros([ksize(1) (R-1)*(R*ksize(2)-R)-1 Nc*(R-1) Nc]);
wspace = zeros([ksize(1) ksize(2)*(R-1) Nc Nc]);

for ii = 1:R-1
    %    wspace(:,R-ii:R-1:end,:,:) = wflip(:,:,1+(ii-1)*Nc:Nc+(ii-1)*Nc,:);
    wspace(:,R-ii:R-1:end,:,:) = w2(:,:,ii:R-1:Nc*(R-1),:);
end

wspace = cat(2, wspace(:,1:(R-1)*ksize(2)/2,:,:), zeros([ksize(1) 1 Nc Nc]),...
    wspace(:,(R-1)*ksize(2)/2+1:end,:,:));

%Set kernel center to 1
for ii = 1:Nc
    %      wspace(ceil(ksize(1)/2),R*floor(ksize(2)/2):R*floor(ksize(2)/2)+R-2,ii,ii) = 1;
    wspace(ceil(ksize(1)/2),(R-1)*floor(ksize(2)/2)+1,ii,ii) = 1;
end

%flip left/right and flip up/down
wflip = rot90(wspace,2);

%Zero pad to image size
wpad = zpad(wflip, [sx sy Nc Nc]);

% ifft of weight matrix
wim = ifftnd(wpad,opt.dim, 1);

% --- Remove ACS lines form DATA --- %
% Find indices to skip in ACS lines
ind = zeros(arcACS,1);
ind(1:R:end) = 1;
ind = ~ind;
ind = [zeros(floor((sy-arcACS)/2),1); ind; zeros(ceil((sy-arcACS)/2),1)] == 1;

DATA_no_ACS = DATA;
DATA_no_ACS(:,ind,:) = 0;

% IFFT aliased coil images
DATAim = ifftnd(DATA_no_ACS, opt.dim, 1);
im2 = zeros([sx sy]);
for ii = 1:Nc
    wcurr = reshape(wim(:,:,ii,:), [sx sy Nc]);
    im2(:,:,ii) = sum(wcurr.*DATAim,3);
end
toc;

%SOS coil combination
im2sos = sos(im2);

h = figure;
subplot(2,1,1);imagesc(abs(reshape(wim(:,:,4,:), [sx sy*nc]))); colormap gray; axis off;
colorbar;

subplot(2,1,2);imagesc(angle(reshape(wim(:,:,4,:), [sx sy*nc]))); colormap jet; axis off;
colorbar;

h = figure;
subplot(2,1,1);imagesc(abs(DATAim(:,:))); colormap gray; axis off;
subplot(2,1,2); imagesc(angle(DATAim(:,:))); colormap jet; axis off;


h = figure; imagesc(abs(im2(:,:,3))); colormap gray; axis square; axis off;
h = figure; imagesc(angle(im2(:,:,3))); colormap jet; axis square; axis off;
h = figure; imagesc(im2sos); colormap gray; axis square; axis off;


%% GRAPPA G-factor
[nx, ny, ~,~] = size(nk);
noise = reshape(nk(:,:,:,1), [nx*ny Nc]);

%sig1 = eye(Nc)*nx*ny;
sig2 = cov(noise)*nx*ny;
%sig3 = corrcoef(noise)*nx*ny;

sig = sig2;
invsig = inv(sig);
g = zeros([sx sy Nc]);
tic;
wim = wim/max(wim(:));

gsos = zeros([sx sy]);


for ii = 1:sx
    for jj = 1:sy       
        % coil by coil g factor
        W = wim(ii,jj,:,:);
        W = reshape(W, [Nc Nc]);
        for kk = 1:Nc
            %W = squeeze(wim(ii,jj,:,:));
            %W = W*W';
            gmat = abs(W*sig*W').^.5/abs(sig(kk,kk)).^.5;
            g(ii,jj,kk) = gmat(kk,kk);
        end
        
        % SOS g factor
        %W = squeeze(wim(ii,jj,:,:));
        %W = W*W';
        %p = squeeze(im2(ii,jj,:)/im2sos(ii,jj));
        p = im2(ii,jj,:)/im2sos(ii,jj);
        p = p(:);
        gsos(ii,jj) = abs((p'*W)*sig*(p'*W)').^.5/abs(p'*sig*p).^.5;
        
    end  
end
toc;

% % SOS g factor
% tic;
% gsos = zeros([sx sy]);
% for ii = 1:sx
%     for jj = 1:sy
%             W = squeeze(wim(ii,jj,:,:));
%             %W = W*W';
%             p = squeeze(im2(ii,jj,:)/im2sos(ii,jj));
%             gsos(ii,jj) = abs((p'*W)*sig*(p'*W)').^.5/abs(p'*sig*p).^.5;
%     end
% end
% toc;

h = figure; imagesc(g(:,:)); colormap jet; colorbar;  axis off;
h = figure; imagesc(gsos); axis off square; colormap jet; colorbar;



%figure; imagesc([abs(sig1) abs(sig2) abs(sig3)]); colormap jet; colorbar;
% %% G-factor SENSE
% %
% base = ifftnd(zpad(calib, sx, sy, Nc), opt.dim, 1);
%
% DATA_SENSE = DATA_no_ACS;
%
% [x, y] =  find(abs(DATA_SENSE(:,:,2,1) == 0));
% y = unique(y);
%
% DATA_SENSE(:,y,:,:) = [];
% DATA_SENSE = zpad(DATA_SENSE, sx, sy/R, Nc);
% imsense = ifftnd(DATA_SENSE, opt.dim, 1);
%
% % Generate Coil Sensitivity Map
% sm = 20;
% smap = senseMap(base, sm);
%
% tic;
% [im3, gsense] =  HPDsenseR2(imsense, smap, eye(8));
% toc;
%
% figure; imagesc(im3); axis square; colormap gray;
% figure; imagesc(gsense); axis square; colorbar;