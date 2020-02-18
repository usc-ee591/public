% generate the movie from contours
% ZYH, 02/02/2013

load data

nontongue = data.increasetempres.nontongue;
tongue = data.increasetempres.tongue;

[ptnum framenum] = size(nontongue);

% 2DFT
n = 84;
krange = (-n/2: 1: n/2-1)/n;
[kx ky] = meshgrid(krange, krange);

% video specs
avicolormap = gray(256);
aviobj = avifile('vtPhantom.avi','Compression','None');
aviobj.Fps = 1/3e-3/14;

for n = 1:framenum
    progress = ['progress: ' num2str(n) ' of ' num2str(framenum)];
    disp(progress);
    
    % raw data of different parts
    raw_nontongue = Poly2Fourier(real(nontongue(:,n)), imag(nontongue(:,n)), kx, ky);
    raw_tongue = Poly2Fourier(real(tongue(:,n)), imag(tongue(:,n)), kx, ky);

    % add raw data together
    raw = raw_nontongue + raw_tongue;

    % every 3ms*14 = 42ms, generate a frame
    if mod(n, 14) == 1
        im = ift(raw);
        im_8bit = im2eightbit(abs(im), 255, 0);
        im_8bit = flipud(im_8bit);
        aviobj = addframe(aviobj, im2frame(im_8bit, avicolormap));
    end
end

aviobj = close(aviobj);