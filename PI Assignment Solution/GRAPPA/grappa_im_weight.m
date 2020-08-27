function wim = grappa_im_weight(w, Nc, R, ksize, padsize, Nacq)
% GRAPPA_IM_WEIGHT converts grappa kernel weights from k-space into the
% image domain. 
%   wim = GRAPPA_IM_WEIGHT(w, Nc, R, ksize, padsize, Nacq) transforms
%   grappa convolution weights, w, in k-space into the image domain , wim, 
%   to allow multiplication in the image domain. 
%
%   Input:  Required:
%           w - GRAPPA kernel weights
%           Nc - Number of coils
%           R - acceleration factor outside of ACS lines
%           ksize - kernel size
%           padsize - reconstructed image size
%           Nacq - number of acquired samples
%
%   Output: 
%            wim - GRAPPA weight in image domain
%
% Author: Terrence Jao
% Date: 2015
% References: 
% 1. Breuer FA, Kannengiesser SAR, Blaimer M, Seiberlich N, Jakob PM, 
% Griswold MA. General formulation for quantitative G-factor calculation 
% in GRAPPA reconstructions. Magn. Reson. Med. 2009;62:739–46.
% 2. Robson PM, Grant AK, Madhuranthakam AJ, Lattanzi R, Sodickson DK,
% McKenzie CA. Comprehensive quantification of signal-to-noise ratio and 
% g-factor for image-based and k-space-based parallel imaging 
% reconstructions. Magn. Reson. Med. 2008;60:895–907

% --- Reshape Data --- %
w = reshape(w, [Nc*(R-1) ksize(1) ksize(2) Nc]);
w = permute(w, [2 3 1 4]);

%--- Setting reconstruction weights in the correct position ---%
wspace = zeros([ksize(1) ksize(2)*R Nc Nc]);
for ii = 1:R-1
    wspace(:,R-ii:R:end,:,:) = w(:,:,ii:R-1:Nc*(R-1),:);
end

%--- Set kernel center to 1 ---%
for ii = 1:Nc
    wspace(ceil(ksize(1)/2),R*floor(ksize(2)/2),ii,ii) = 1;
end

% Old Version - Had Errors
% wspace = zeros([ksize(1) ksize(2)*(R-1) Nc Nc]);
% 
% for ii = 1:R-1
%     wspace(:,R-ii:R-1:end,:,:) = w(:,:,ii:R-1:Nc*(R-1),:);
% end
% wspace = cat(2, wspace(:,1:(R-1)*ksize(2)/2,:,:), zeros([ksize(1) 1 Nc Nc]),...
%     wspace(:,(R-1)*ksize(2)/2+1:end,:,:));
% for ii = 1:Nc
%     wspace(ceil(ksize(1)/2),(R-1)*floor(ksize(2)/2)+1,ii,ii) = 1;
% end

%--- flip left/right and flip up/down ---%
wflip = rot90(wspace,2);

%--- Zero pad to image size ---%
wpad = zpad(wflip, [padsize Nc Nc]);

%--- Inverse Fourier Transform ---%
% wim = ifftnd(wpad,[1 2], 1)*Nacq;
wim = ifftnd(wpad,[1 2], 1)*prod(padsize)/R;


