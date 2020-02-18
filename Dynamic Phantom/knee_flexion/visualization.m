load data

% spatial: 256x256 -> 84x84, frame rate: 1000/3 -> 1000/42 
fsurface = data.increasetempres.fsurface(:, 1:14:end) * (84/256);
patella = data.increasetempres.patella(:, 1:14:end) * (84/256);
pad = data.increasetempres.pad(:, 1:14:end) * (84/256);
ffat = data.increasetempres.ffat(:, 1:14:end) * (84/256);
femur = data.increasetempres.femur(:, 1:14:end) * (84/256);
tibia = data.increasetempres.tibia(:, 1:14:end) * (84/256);
bmeniscus = data.increasetempres.bmeniscus(:, 1:14:end) * (84/256);
bsurface = data.increasetempres.bsurface(:, 1:14:end) * (84/256);

[ptnum framenum] = size(pad);

% 2DFT sequence
n = 84;
krange = (-n/2: 1: n/2-1)/n;
[kx ky] = meshgrid(krange, krange);

% video spec
avicolormap = gray(256);
aviobj = avifile('kneePhantom.avi','Compression','None');
aviobj.Fps = 1000/3/14;

for n = 1:framenum
    progress = ['progress: ' num2str(n) ' of ' num2str(framenum)];
    disp(progress);
    
    % calculate FT data of each invidual polygon
    raw_fsurface = Poly2Fourier(real(fsurface(:,n)), imag(fsurface(:,n)), kx, ky);
    raw_patella = Poly2Fourier(real(patella(:,n)), imag(patella(:,n)), kx, ky);
    raw_pad = Poly2Fourier(real(pad(:,n)), imag(pad(:,n)), kx, ky);
    raw_ffat = Poly2Fourier(real(ffat(:,n)), imag(ffat(:,n)), kx, ky);
    raw_femur = Poly2Fourier(real(femur(:,n)), imag(femur(:,n)), kx, ky);
    raw_tibia = Poly2Fourier(real(tibia(:,n)), imag(tibia(:,n)), kx, ky);
    raw_bmeniscus = Poly2Fourier(real(bmeniscus(:,n)), imag(bmeniscus(:,n)), kx, ky);
    raw_bsurface = Poly2Fourier(real(bsurface(:,n)), imag(bsurface(:,n)), kx, ky);

    % add all raw data together
    raw = raw_fsurface*0.7 + raw_patella*0.9 + raw_pad + raw_ffat*0.8 + raw_femur + raw_tibia + raw_bmeniscus*0.5 + raw_bsurface;

    % generate images
    im = ift(raw);
    im_8bit = im2eightbit(abs(im), 255, 0);
    im_8bit = flipud(im_8bit);

    aviobj = addframe(aviobj, im2frame(im_8bit, avicolormap));
end

aviobj = close(aviobj);