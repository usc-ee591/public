function [g, gsos, varargout] = grappa_gfact(wim, sig, im, smap, calc_g_coil)
% GRAPPA_GFACT calcualtes grappa g-factor as well as SNR of images
%   [g, gsos] = grappa_gfact(wim, sig, im, smap, calc_g_coil) calculates
%   the individual coil g-factors, g, when calc_g_coil is 1 and the coil
%   combined g-facotr, gsos, given the grappa weights in the image domain,
%   wim, the noise covariance matrix, sig, the reconstructed images, im,
%   and sensitivity map, smap. 
%
%   [g, gsos, SNR_b1, SNR_sos, im_b1] = grappa_gfact(wim, sig, im, smap,
%   clac_g_coil) have optional outputs that calculates image SNR using
%   optimal b1 combination, SOS combination, and the optimal b1 combined
%   images. 
%
%   Inputs:     Required:
%               wim - (sx, sy, Nc) GRAPPA image domain weights
%               sig - coil covariance matrix (Nc, Nc)
%               im - reconstructed images (sx, sy, Nc)
%               smap - coil sensitivity maps (sx, sy, Nc)
%               calc_g_coil - (0 or 1) to calculate individual coil
%               g-factor Individual coil-g-factors take a long time to
%               calcualte (add as an optional parameter using input parser 
%               later)
%
%   Outputs:    Required:
%               g - individual coil g-factor
%               gsos - coil comibined g-factor
%               Optional:
%               SNR_sos - sos combined SNR
%               SNR_b1 - b1 combined SNR
%               im_b1 - b1 combined images. 
%
% Author: Terrence Jao
% Date:   2015
% Reference: 
% 1. Breuer FA, Kannengiesser SAR, Blaimer M, Seiberlich N, Jakob PM, 
% Griswold MA. General formulation for quantitative G-factor calculation 
% in GRAPPA reconstructions. Magn. Reson. Med. 2009;62:739–46.

[sx, sy, Nc,~] = size(wim);
im_sos = sos(im);

% --- Allocate Arrays --- %
g = zeros([sx sy Nc]);
gsos = zeros([sx sy]);
SNR_b1 = zeros([sx sy]);
SNR_sos = zeros([sx sy]);
im_b1 = zeros([sx sy]);

for ii = 1:sx
    for jj = 1:sy
        
        % --- Single Coil g factor --- %
        W = wim(ii,jj,:,:);
        W = reshape(W, [Nc Nc]);
        if calc_g_coil
            for kk = 1:Nc
                gmat = sqrt(abs(W*sig*W'))./sqrt((sig(kk,kk)));
                g(ii,jj,kk) = gmat(kk,kk);
            end
        end
        
        % --- Coil Combined g factor --- %
        p = im(ii,jj,:)./im_sos(ii,jj);
        p = p(:);
        gsos(ii,jj) = sqrt(abs((p'*W)*sig*(p'*W)'))/...
            sqrt(abs((p'*eye(Nc))*sig*(p'*eye(Nc))'));
        
        % Define variables for SNR calculation
        b = smap(ii,jj,:);      b = b(:);
        p = im(ii,jj,:);        p = p(:);
        
        %%%%%% THIS IS WRONG!!!!!!!!! %%%%%%%%%%%%%%%%%%%%%%%
        
        % SNR for b1 coil combination
        %g_curr = g(ii,jj,:);    g_curr = g_curr(:);
        %SNR_b1(ii,jj) = abs((p./g_curr)'/sig*b)/sqrt(b'/sig*b);
        % SNR_b1(ii,jj) = abs((p./g_curr)'/sig*b)/sqrt(b'/sig*b);
        
        % An SNR-optimal image combination, however, requires the knowledge
        % of the coil sensitivity profiles for both nonnormalized and
        % B1-normalized image combination. The difference between both
        % combination methods is just a scalar scaling factor for each
        % image pixel that depends only on the coil sensitivities. However,
        % since the GRAPPA g-factor is given in relation to the fully
        % encoded image SNR on a pixel-by-pixel basis this scaling
        % factor cancels out.
        
        % --- SNR for sos coil combination --- %
        if nargout > 2
            SNR_sos(ii,jj) = sqrt(p'/sig*p);
            
            %Divide by gfactor? Triantafyllou et. al. multiplied...
            %         SNR_sos(ii,jj) = sqrt(p'/sig*p)./gsos(ii,jj);
        end
        % --- SNR for b1 coil combination --- %
        if nargout > 3
            %Kellman McVeigh 2007 Erratum
            SNR_b1(ii,jj) =  abs(b'/sig*p)/sqrt(b'/sig*b);
            
            %Divide by gfactor? Triantafyllou et. al. multiplied...
            %         SNR_b1(ii,jj) = SNR_b1(ii,jj)./gsos(ii,jj);
            
        end
        if nargout > 4
            % --- Optimal B1 coil combination --- %
            % Roemer 1990
            im_b1(ii,jj) = real(pinv(transpose(b)/...
            sig*conj(b))*transpose(b)/sig*conj(p));
            
            %Following Kellman McVeigh Derivation 2007
%             im_b1(ii,jj) = real((b'/sig*p)/(b'/sig*b));
        end
    end
end

% Extra Outputs
if nargout > 2
    varargout{1} = SNR_sos;
end
if nargout > 3
    varargout{2} = SNR_b1;
end
if nargout > 4
    varargout{3} = im_b1;
end