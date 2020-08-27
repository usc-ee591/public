function [im, res, w] = grappa_tc(DATA, ksize, arcACS)

[sx,sy,Nc,~,~] = size(DATA);                    % Dimension of data
R = ceil((sy-arcACS)/sum(DATA(1,:,1,1)==0));              % Find acceleration factor outside ACS
calib = crop(DATA(:,:,:,1),[sx,arcACS,Nc]);     % Get calibration data
[ny, nx, ~] = size(calib);
%--------------------------------------------------------------------------
% Generate GRAPPA weights
%--------------------------------------------------------------------------
count = 0;
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

% Fill in missing k-space points

%--------------------------------------------------------------------------
% Regular GRAPPA (fill in Kspace)
%--------------------------------------------------------------------------

res = DATA;
%res2 = DATA;
%DATA2 = DATA;
DATA = zpad(DATA, [sx+ksize(1), sy+ksize(2), Nc]);

for y =1:sy
    for x = 1:sx
        if sum(abs(res(x,y,:)),3) == 0
            xind = (x-ceil(ksize(1)/2)+1:1:x-ceil(ksize(1)/2)+ksize(1)-1+1)+1;
            yind = (y-R*floor(ksize(2)/2)+1:R:y+R*ksize(2)-(R-1)-R*floor(ksize(2)/2)+1)+1;
   %         xind
   %         yind
            tempsrc = DATA(xind,yind,:);
            tempsrc = tempsrc(:);
            res(x,y:y+R-2,:) = reshape(w*tempsrc, [R-1 Nc]);
        end
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
%im2 = ifftnd(res2, [1 2], 1);
end