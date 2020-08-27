function [recon,g,ws_img] = grappa2D(sig,acs,af,R); %Nacq); 

%  This code is based on opengrappa by Mark Griswold 
%
%  modyfied by Felix Breuer 24/05/05
%  unnecessary for-loops (for afind=1:af-1, end) removed 
%  cycling boundary assumption removed
%  indexing fixed
%
%  modified by Felix Breuer 25/10/07
%  grappa weights transformed into the image space 
%  grappa reconstruction takes place in image space
%
%  modified by Felix Breuer 10.05.08
%  grappa g-factor calculation included for sos-combined images
%   
%  [recon,g,ws_img] = opengrappa(sig,acs,af);
%
%  This is a teaching version of the GRAPPA reconstruction code.
%  GRAPPA Weights are determined in k-space - Image reconstruction is
%  performed in image space
%       
%   IN:         sig                reduced data set         (#coils, Ky./af, Kx)
%               acs                autocalibration lines    (#coils, #acs_ky, #acs_ky)    
%               af                 Acceleration factor      (integer)
%               R                  noise covariance matrix  (#coils,#coils)    
%                                  
%
%   OUT:        recon              SOS combined GRAPPA image   (Ny, Nx)        
%               g                  GRAPPA gfactor              (Ny, Nx)
%               
%   Some things to think about when using this code:
%
%           -The ACS lines used for reconstruction are NOT included in the final reconstructed
%           data sets. If you want to do this, you can do it after reconstruction. Please check
%           that they are lined up with the reconstructed data. I have not checked this.
%
%           -Since the ACS lines are not included, feel free to use a different imaging sequence
%           for acquisition of the ACS lines. We have seen some advantage in doing this when
%           the sequence used for the reduced acquisition is very flow sensitive, for example.
%           This can also be faster in many cases.
%
%           -The 4x5 block size is normally optimal for most applications, but if you need  
%           something faster, you should try the 4x3 code which uses a smaller block size.
%
%   
%   1) This code is strictly for non-commercial applications. The code is protected by
%      multiple patents.
%   2) This code is strictly for research purposes, and should not be used in any
%      diagnostic setting.
%
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%   This code also calculates the grappa g-factor for uncombined GRAPPA images
%   directly from the GRAPPA reconstruction weights.
%   
%   The g-factor for each image pixel in each coil is simply:
%   g = sqrt(abs(diag(ws_img*R*ws_img')))./sqrt(diag(R))
%   
%   The noise covariance matrix R has to be derived from noise only samples (#coils,#samples)
%   R = cov(noise')
%
%   
%   It is important to include potential noise correlations (R) for accurate
%   g-factor results!!!
%
%   10.05.2008 Felix Breuer (breuer@mr-bavaria.de)
%


[nc,ny,nx]=size(sig);
[nc_acs,nyacs,nxacs]=size(acs);     %Get the size of both the input data and the acs data

if nc_acs~=nc
    disp('Error! The number of coils has to be the same for both inputs!')
    recon_sos=[];
    g_sos =[];
    return
end

% if af>nc
%     disp('Error! The acceleration factor must not exceed number of coils!')
%     recon_sos=[];
%     g_sos =[];
%     return    
% end

if nargin < 4;
        R = eye(nc);
        disp('No noise correlations has been passed ......')
        disp('Assuming perfect coils without correlations......')
        no_corr = 1;
               
else
        sz = size(R);
        no_corr = 0;
        if size(sz)~=2 | sz(1)~=sz(2) | sz(1)~=nc
            disp('Error! The dimension of noise covariance matrix has to be (#coils,#coils) !')
            recon = [];
            g = [];
            return
        end   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  calculate the weights for a 4x5 kernel in k-space from ACS data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                

%   Simple example at 2x:            
%
%                   -O-O-O-O-O-     1   
%                   - - - - - -     2
%                   -O-O-O-O-O-     3       
%                   - - -X- - -     4         
%                   -O-O-O-O-O-     5
%                   - - - - - -     6
%                   -O-O-O-O-O-     7
%                   - - - - - -     8
%
%   The circles are the source points, and the X is the target point.


%  slide through the ACS data and collect all source points in matrix 
%  src and all target points in matrix trg 


srcx = 5;                         % should be odd                  
srcy = 4;                         % can now be even and odd 

src=zeros(nc*srcy*srcx,(nyacs-(srcy-1)*af)*(nxacs-(srcx-1)));
trg=zeros(nc*af,(nyacs-(srcy-1)*af)*(nxacs-(srcx-1)));


cnt = 0;  % This is a lazy counter. could be done much faster.

for xind=floor(srcx./2)+1:nxacs-floor(srcx./2),
    for yind=1:nyacs-(srcy-1)*af,
        cnt=cnt+1;
                
        src(:,cnt)=reshape(acs(:,yind:af:yind+(srcy-1)*af,xind-floor(srcx./2):xind+floor(srcx./2)),nc*srcy*srcx,1);                   
                                     
        %trg(:,cnt)=reshape(acs(:,yind+(srcy./2-1)*af:yind+(srcy./2)*af-1,xind),nc*af,1);    %These are the target point
        
        % allows even and odd sourceblock size
        trg(:,cnt)=reshape(acs(:,yind+floor((af*(srcy-1)+1)/2) - floor(af/2) : yind + floor((af*(srcy-1)+1)/2) - floor(af/2) + af -1 ,xind),nc*af,1);
    end
end


% allows regularization --> see helper function at the end of this code
%ws=trg*pinv_reg(src,1e-4);
ws = trg*pinv(src);
    
                                                                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                                   
%                                                                    
%  Calculate grappa weights for reconstruction in image space                                                                  
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ws_k = zeros(nc,nc,ny*af,nx);

ws_tmp = reshape(ws,[nc,af,nc,srcy,srcx]);                                 %Reshape weight set 

ws_tmp = flipdim(flipdim(ws_tmp,4),5);                                     %flip source points in ky and kx for the convolution              


    for k=1:af,
        ws_kernel(:,:,k:af:af*srcy,:) = ws_tmp(:,k,:,:,:);                 %reconstruction kernel
    end    


%imagesc(squeeze(sum(abs(ws_kernel(1,:,:,:)),2)))
%imagesc(makesos(makesos(ws_kernel)))


ws_k(:,:,ceil((ny-srcy)*af/2)+1:ceil((ny+srcy)*af/2),ceil((nx-srcx)/2+1):ceil((nx+srcx)/2)) = ws_kernel;  %put reconstruction kernel in the center of matrix


tmp0 = ifftshift(ws_k,3);           % shift in phase
tmp1 = ifftshift(tmp0,4);           % shift in read

tmp0 = ifft(tmp1,[],3);             % ifft in phase
tmp1 = ifft(tmp0,[],4);             % ifft in read

tmp0 = ifftshift(tmp1,3);           % shift in phase
tmp1 = ifftshift(tmp0,4);           % shift in read 

ws_img = ny*nx*tmp1;
% 2017-02-15 TJ modification for proper scaling---ny*nx is correct, below
% Nacq is wrong
% ws_img = Nacq*tmp1;


%ws_img = ny*nx*ifftshift(ifftshift(ifft(ifft(ifftshift(ifftshift(ws_k,3),4),[],3),[],4),3),4);    %Fouriertransform in image space and scale to final matrix size




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Apply weights to folded images (GRAPPA reconstruction in image space -> Convolution Theorem)
%                                                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


sig_red = zeros(nc,ny*af,nx);

sig_red(:,1:af:end,:) = sig;                                             

tmp0 = ifftshift(sig_red,2);         % shift in phase
tmp1 = ifftshift(tmp0,3);            % shift in read 

tmp0 = ifft(tmp1,[],2);              % ifft in phase
tmp1 = ifft(tmp0,[],3);              % ifft in read

tmp0 = ifftshift(tmp1,2);            % shift in phase
tmp1 = ifftshift(tmp0,3);            % shift in read 


img_red = tmp1;

clear tmp0
clear tmp1


%img_red = ifftshift(ifftshift(ifft(ifft(ifftshift(ifftshift(sig_red,2),3),[],2),[],3),2),3);

recon = zeros(nc,ny*af,nx);
for k = 1:nc, 
 recon(k,:,:) = sum(squeeze(af*ws_img(k,:,:,:)).*img_red,1);             % This is the uncombined GRAPPA reconstruction;
end

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Calculate grappa g-factor for cobined and uncombined imagess
%
%  See Breuer et al. Magn Reson Med. 2009 Sep;62(3):739-46
%                                                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% allocate memory for combined g-factor
g = zeros(ny*af,nx);

% allocate memory for uncombined g-factor
% g = zeros(nc,ny,nx);
[nc, nyacs_old, nxacs_old] = size(acs);

nyacs = min(nyacs_old,32);
nxacs = min(nxacs_old,32);


acs = acs(:,nyacs_old/2-nyacs/2+1:nyacs_old/2+nyacs/2,nxacs_old/2-nxacs/2+1:nxacs_old/2+nxacs/2);
size(acs)

if nargout > 1,
        if no_corr,
            disp('Be extremely careful! g-factor results might be inacurate......') 
        end
       
            filterPhase = reshape(tukeywin(nyacs,1),[1 nyacs 1]);
            acs = bsxfun(@times,acs,filterPhase);
            filterRead = reshape(tukeywin(nxacs,1),[1 1 nxacs]);
            acs = bsxfun(@times,acs,filterRead);
                                
            acs_filt = zeros(nc,ny*af,nx);
            acs_filt(:,floor((ny*af-nyacs)/2)+1:floor((ny*af-nyacs)/2)+nyacs,floor((nx-nxacs)/2)+1:floor((nx-nxacs)/2)+nxacs) = acs;
            
            
            tmp0 = ifftshift(acs_filt,2);        % shift in phase
            tmp1 = ifftshift(tmp0,3);            % shift in read 

            tmp0 = ifft(tmp1,[],2);              % ifft in phase
            tmp1 = ifft(tmp0,[],3);              % ifft in read

            tmp0 = ifftshift(tmp1,2);            % shift in phase
            tmp1 = ifftshift(tmp0,3);            % shift in read 

            recon_filt = tmp1;

            for y = 1:ny*af,
                for x = 1:nx,
                    W = squeeze(ws_img(:,:,y,x));            % Weights in image space
                    tmp = squeeze(recon_filt(:,y,x));
                    n = tmp'./sqrt(sum(abs(tmp).^2,1)); 
                    
                    %g(:,y,x) = sqrt(abs(diag(W*R*W')))./sqrt(diag(R));
                    g(y,x) = sqrt(abs((n*W)*R*(n*W)'))./sqrt(abs((n*eye(nc))*R*(n*eye(nc))'));       % This is the generalized g-factor formulation 
                                                                                                     % for an arbitrary set of coil combining coefficients n
                end

            end
end

function X = pinv_reg(A,lambda)
%PINV   Pseudoinverse.
%   X = PINV(A) produces a matrix X of the same dimensions
%   as A' so that A*X*A = A, X*A*X = X and A*X and X*A
%   are Hermitian. The computation is based on SVD(A) and any
%   singular values less than a tolerance are treated as zero.
%   The default tolerance is MAX(SIZE(A)) * NORM(A) * EPS.
%
%   PINV(A,TOL) uses the tolerance TOL instead of the default.
%
%   See also RANK.

%   Copyright 1984-2001 The MathWorks, Inc. 
%   $Revision: 5.11 $  $Date: 2001/04/15 12:01:37 $
[m,n] = size(A);

if n > m
   X = pinv_reg(A',lambda)';
else
    
   AA = A'*A;

   S = svd(AA,0);
   
   S = sqrt(max(abs(S)));
   X = (AA+eye(size(AA)).*lambda.*S.^2)\A'; 
  
end
