function [im, res, w] = grappa_tc_2(DATA, ksize, arcACS, varargin)
% GRAPPA_TC_2 GRAPPA Parrallel Imaging Reconstruction
%   GRAPPA_TC_2(DATA, ksize, arcACS) performs GRAPPA reconstruction with a
%   ksize kernel size on raw under-sampled k-space DATA acquired with
%   arcACS calibration lines in the central k-space region.
%
%   Inputs:     Required:
%               DATA - raw k-space (sx, sy, Nc)
%               ksize - kernel size [kx ky]
%               arcACS - number of ACS lines
%
%               Optional:
%               R - Undersampling factor outside ACS
%               mask - mask of acquired samples (default calculated from
%               DATA)
%               PF - Partial Fourier undersampling factor (default 1)
%
%   Outputs:    im  - reconstructed image (sx, sy, Nc)
%               res - grappa filled k-space (sx, sy, Nc)
%               w - grappa weights
%
% Author:       Terrence Jao
% Date:         ??? 2015?
% Reference:
% 1. Breuer FA, Kannengiesser SAR, Blaimer M, Seiberlich N, Jakob PM,
% Griswold MA. General formulation for quantitative G-factor calculation
% in GRAPPA reconstructions. Magn. Reson. Med. 2009;62:739–46.
%--------------------------------------------------------------------------
%% parse input
%--------------------------------------------------------------------------
p = inputParser;
p.addRequired('DATA');
p.addRequired('ksize');
p.addRequired('arcACS');
p.addParameter('R', nan, @isscalar);
p.addParameter('mask', [0 0], @(x)numel(x)>1);
p.addParameter('PF', 1, @isscalar);
p.addParameter('w', [], @(x)numel(x)>1);
p.parse('DATA', 'ksize', 'arcACS', varargin{:});

results = p.Results;
R = results.R;
mask = results.mask;
PF = results.PF;
w = results.w;

[sx,sy,Nc,~,~] = size(DATA);
% Dimension of data
if sum(mask) == 0
    mask = DATA(:,:,1,1);
    mask = mask~=0;
end

if isnan(R)
    R = round((sy*PF-arcACS)/(sum(mask(floor(sx/2),:,1,1)~=0)-arcACS));
end % Find acceleration factor outside ACS

if isempty(w)
    calib = crop(DATA(:,:,:,1),[sx,arcACS,Nc]);     % Get calibration data
    [nx, ny, ~] = size(calib);
    %--------------------------------------------------------------------------
    % Generate GRAPPA weights
    %--------------------------------------------------------------------------
    count = 0;
    for y = 1:ny-(R*(ksize(2)-1))
        for x = 1:nx-(ksize(1)-1)
            count = count+1;
            %         temp = circshift(calib, [y -x]);
            xindsrc = x:x+ksize(1)-1;
            yindsrc = y:R:y+R*(ksize(2)-1);
            
            xindtg = ceil(mean(xindsrc));
            yindtg = yindsrc(floor(ksize(2)/2))+1:yindsrc(floor(ksize(2)/2)+1)-1;
            
            tempsrc = calib(xindsrc,yindsrc,:);
            temptg = calib(xindtg,yindtg,:);
            src(:,count) = tempsrc(:);
            stg(:,count) = temptg(:);
        end
    end
    
    w = stg*pinv(src);
    
    % Fill in missing k-space points
end

%--------------------------------------------------------------------------
% Regular GRAPPA (fill in Kspace)
%--------------------------------------------------------------------------

res = DATA;

[~, yind] = find(sum(mask(:,:,1,1),1) == 0);
% if (sum(sy-(1-PF)/2*sy+1:sy==yind(length(yind)-length((sy-(1-PF)/2*sy+1:sy))+1:length(yind)))==length(sy-(1-PF)/2*sy+1:sy)) % Symmetrical PF
%     yind(yind < (1-PF)/2*sy) = [];
%     yind(yind > sy-(1-PF)/2*sy) = [];
% else
    yind(yind < (1-PF)*sy) = [];
%end
yind = unique(yind);
yind = yind(1:(R-1):end);

%Zero-pad X
xpad_1 = ceil((ksize(1)-1)/2);
xpad_2 = floor((ksize(1)-1)/2);
xpad1 = zeros([xpad_1, sy, Nc]);
xpad2 = zeros([xpad_2, sy, Nc]);
DATA = cat(1, xpad1, DATA, xpad2);

%Zero-pad Y which depends on kernel size and acceleration factor, not
%centered
[~,yacq] = find(sum(mask(:,:,1,1),1) ~= 0);
ypad_1 = R*(floor(ksize(2)/2)-1)+mod(R-(yacq(1)-1),R);
ypad_2 = R*(ceil(ksize(2)/2)-1)+mod(R-(sy-yacq(end)),R);
ypad1 = zeros([sx+ksize(1)-1,ypad_1 , Nc]);
ypad2 = zeros([sx+ksize(1)-1,ypad_2, Nc]);
DATA = cat(2, ypad1, DATA, ypad2);


% offsetx = floor(ksize(1)/2);
% offsety = floor(ksize(2)/2)*R;

for yy = 1:length(yind)
    y = yind(yy);
    for x = 1:sx
        %         if sum(abs(res(x,y,:)),3) == 0
        
        xindsrc = x:x+ksize(1)-1;
        %              x
        yindsrc = (y:R:y+R*(ksize(2)-1))-1;
        %             y:y+R-2
        
        %             xindtg = ceil(mean(xindsrc));
        %             yindtg = yindsrc(floor(ksize(2)/2))+1:yindsrc(floor(ksize(2)/2)+1)-1;
  %  yindsrc
        tempsrc = DATA(xindsrc,yindsrc,:);
        tempsrc = tempsrc(:);
        
        res(x,y:y+R-2,:) = reshape(w*tempsrc, [R-1 Nc]);
        %         end
    end
end


% Old version leaves edges with holes

% for y = R*floor(ksize(2)/2):1:sy-(ksize(2)*R-1)
%     for x = ceil(ksize(1)/2):sx-ksize(1)-1
%         if sum(abs(DATA2(x,y:y+R-2,:)),3) == 0
%             tempsrc = DATA2(x-ceil(ksize(1)/2)+1:1:x-ceil(ksize(1)/2)+ksize(1)-1+1,...
%                 y-R*floor(ksize(2)/2)+1:R:y+R*ksize(2)-(R-1)-R*floor(ksize(2)/2)+1,:);
%             tempsrc = tempsrc(:);
%             res2(x,y:y+R-2,:) = reshape(w*tempsrc, [R-1 Nc]);
%         end
%     end
% end

im = ifftnd(res, [1 2] ,1);

end