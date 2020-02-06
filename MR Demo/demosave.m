clc
%	HIGH PASS FILTERED IMAGE
%
%	Here is the corresponding high-pass filtered image
%	in the phase encode direction.
%	This is based on zeroing out the center 64 phase encodes.

headdiff= headraw-head64;
figure(1)
low=min(min(abs(headdiff)));
high=max(max(abs(headdiff)));
dispim(headdiff',-100,high);
title('Center 64 Phase Encodes Zeroed Out (Brain)');
xlabel('kx');
ylabel('ky');

figure(2)
im = reconim(headdiff);	% please wait a few seconds for reconstruction
low=min(min(abs(im)));
high=max(max(abs(im)));
dispim(flipud(im),low,high/20);
title('High-Pass Filtered Image');
ylabel('Readout Direction');
xlabel('Phase Encode Direction');

