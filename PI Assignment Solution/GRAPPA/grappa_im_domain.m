function wim = grappa_im_domain(w, Nc, R, ksize, padsize, DATA, arcACS)

w = reshape(w, [Nc*(R-1) ksize(1) ksize(2) Nc]);
w = permute(w, [2 3 1 4]);

% wspace = zeros([ksize(1) (R-1)*(R*ksize(2)-R)-1 Nc*(R-1) Nc]);
wspace = zeros([ksize(1) ksize(2)*(R-1) Nc Nc]);

for ii = 1:R-1
    %    wspace(:,R-ii:R-1:end,:,:) = wflip(:,:,1+(ii-1)*Nc:Nc+(ii-1)*Nc,:);
    wspace(:,R-ii:R-1:end,:,:) = w(:,:,ii:R-1:Nc*(R-1),:);
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
wpad = zpad(wflip, [padsize Nc Nc]);

% ifft of weight matrix
wim = ifftnd(wpad,[1 2], 1)*padsize(1)*padsize(2);

sx = padsize(1);
sy = padsize(2);

% --- Remove ACS lines form DATA --- %
% Find indices to skip in ACS lines
ind = zeros(arcACS,1);
ind(1:R:end) = 1;
ind = ~ind;
ind = [zeros(floor((sy-arcACS)/2),1); ind; zeros(ceil((sy-arcACS)/2),1)] == 1;

DATA_no_ACS = DATA;
DATA_no_ACS(:,ind,:) = 0;

% IFFT aliased coil images
DATAim = ifftnd(DATA_no_ACS, [1 2], 1);
im2 = zeros([sx sy]);
for ii = 1:Nc
    wcurr = reshape(wim(:,:,ii,:), [sx sy Nc]);
    im2(:,:,ii) = sum(wcurr.*DATAim,3);
end

im2 = sos(im2);
figure(100); imagesc(im2);
toc;
