% Vocal Tract Phantom
% ZYH, 02/02/2013
%
% This is the process of making vocal tract phantom. Codes are in cell
% mode, each performs a stage of process.
%
% localizeframes and segmentation has been done, no need to run them. 

%%
% Localize the frames from a videos. This has been done.
% localizeframes;
% disp('localizeframes is done');

%%
% Segment the contours from key frames for phantom. This has been done.
% segmentation;
% disp('segmentation is done');

%%
% Interpolate the contours to make it smooth. Do this please.
interpolation;
disp('interpolation is done');

%%
% Align the contours using Dynamic Time Warping. Do this please.
warping;
disp('warping is done');

%%
% Increase temporal resolution, interpolate aligned pairs. The result temporal
% resolution is 3ms. Do this plsase.
increasetempres;
disp('increasetempres is done');

%%
% Generate movie vtPhantom.avi from the data, using polygon-support Fourier transform to
% obtain synthetic k-space data. Do this please
visualization;
disp('visualization is done');