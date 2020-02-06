
%% create a x,y grid and compute r
[x,y] = meshgrid([-5:0.1:5],[-5:0.1:5]);
r = sqrt(x.^2 + y.^2);

%% sanity check!  make sure they are setup correctly
figure(1);
subplot(131); colorbar;
imagesc(x,[-5 5]);
subplot(132); colorbar;
imagesc(y,[-5 5]);
subplot(133); colorbar;
imagesc(r,[0 5]*sqrt(2));

%% visualize 2D sinc
figure(2);
mesh(x,y,sinc(x).*sinc(y));
title('sinc(x) sinc(y)');

%% visualize 2D jinc
figure(3);
mesh(x,y,jinc(r));
title('jinc(r)');

