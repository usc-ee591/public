load data

% spatial: 128x128 -> 84x84, frame rate: 1000/3 -> 1000/42 
area1 = data.increasetempres.area1(:, 1:14:end) * (84/128);
area2 = data.increasetempres.area2(:, 1:14:end) * (84/128);
area3 = data.increasetempres.area3(:, 1:14:end) * (84/128);
area4 = data.increasetempres.area4(:, 1:14:end) * (84/128);
area5 = data.increasetempres.area5(:, 1:14:end) * (84/128);
area6 = data.increasetempres.area6(:, 1:14:end) * (84/128);
area7 = data.increasetempres.area7(:, 1:14:end) * (84/128);
area8 = data.increasetempres.area8(:, 1:14:end) * (84/128);
area9 = data.increasetempres.area9(:, 1:14:end) * (84/128);
area10 = data.increasetempres.area10(:, 1:14:end) * (84/128);
area11 = data.increasetempres.area11(:, 1:14:end) * (84/128);
area12 = data.increasetempres.area12(:, 1:14:end) * (84/128);
area13 = data.increasetempres.area13(:, 1:14:end) * (84/128);
area14 = data.increasetempres.area14(:, 1:14:end) * (84/128);

[ptnum framenum] = size(area1);

% 2DFT
n = 84;
krange = (-n/2: 1: n/2-1)/n;
[kx ky] = meshgrid(krange, krange);

% video spec
avicolormap = gray(256);
aviobj = avifile('shortaxisPhantom.avi','Compression','None');
aviobj.Fps = 1000/3/14;

for n = 1:framenum
    progress = ['progress: ' num2str(n) ' of ' num2str(framenum)];
    disp(progress);
    
    % generate raw data for each polygon
    raw_area1 = Poly2Fourier(real(area1(:,n)), imag(area1(:,n)), kx, ky);
    raw_area2 = Poly2Fourier(real(area2(:,n)), imag(area2(:,n)), kx, ky);
    raw_area3 = Poly2Fourier(real(area3(:,n)), imag(area3(:,n)), kx, ky);
    raw_area4 = Poly2Fourier(real(area4(:,n)), imag(area4(:,n)), kx, ky);
    raw_area5 = Poly2Fourier(real(area5(:,n)), imag(area5(:,n)), kx, ky);
    raw_area6 = Poly2Fourier(real(area6(:,n)), imag(area6(:,n)), kx, ky);
    raw_area7 = Poly2Fourier(real(area7(:,n)), imag(area7(:,n)), kx, ky);
    raw_area8 = Poly2Fourier(real(area8(:,n)), imag(area8(:,n)), kx, ky);
    raw_area9 = Poly2Fourier(real(area9(:,n)), imag(area9(:,n)), kx, ky);
    raw_area10 = Poly2Fourier(real(area10(:,n)), imag(area10(:,n)), kx, ky);
    raw_area11 = Poly2Fourier(real(area11(:,n)), imag(area11(:,n)), kx, ky);
    raw_area12 = Poly2Fourier(real(area12(:,n)), imag(area12(:,n)), kx, ky);
    raw_area13 = Poly2Fourier(real(area13(:,n)), imag(area13(:,n)), kx, ky);
    raw_area14 = Poly2Fourier(real(area14(:,n)), imag(area14(:,n)), kx, ky);

    % add data from all polygons together
    raw = raw_area1 + raw_area2*.5 + raw_area3*.7 + raw_area4*.5 ...
        + raw_area5*(-.9) + raw_area6*(-.9) + raw_area7 + raw_area8*.2 ...
        + raw_area9*.9 + raw_area10*.2 + raw_area11*.9 + raw_area12*1 ...
        + raw_area13*.5 + raw_area14*.5;

    % generate images
    im = ift(raw);
    im_8bit = im2eightbit(abs(im), 255, 0);
    im_8bit = flipud(im_8bit);

    aviobj = addframe(aviobj, im2frame(im_8bit, avicolormap));
end

aviobj = close(aviobj);