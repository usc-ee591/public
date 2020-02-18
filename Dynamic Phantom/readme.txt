This is a scheme for generating flexible dynamic phantoms with arbitrary spatial and temporal resolution.
It implements the multi-stage algorithm described in the abstract: 
"Flexible Dynamic Phantoms for Evaluating MRI Data Sampling and Reconstruction Methods".

If you have any questions or comments, feel free to contact Yinghua Zhu, yinghuaz@usc.edu

Three phantom: vocal tract, knee, and cardiac (short axis), were generated invidually in different folders.

vtPhantom folder:

main.m		main user interface, start here
data.mat	coutours segmented from key frames 
DTW.m		dynamic time warping algorithm
ift.m		inverse Fourier transform
im2eightbit.m	image resize to 0-255
increasetempres.m	increase temporal resolution of the vertices
interpolation.m	interpolation the boundaries to make it smooth
lac08152010_06_39_06.avi	movie that contains key frames
localizeframes.m	find out the key frames from a movie
Poly2Fourier.m	polygon-support Fourier transform
segmentation.m	segment the boundaries from key frames
visualization.m	generate 2DFT k-space data from vertices, reconstruct and make a phantom movie
warping.m	use dynamic time warping to aligned vertices from different contours


knee folder:

main.m		main user interface, start here
data.mat	coutours segmented from key frames 
DTW.m		dynamic time warping algorithm
ift.m		inverse Fourier transform
im2eightbit.m	image resize to 0-255
increasetempres.m	increase temporal resolution of the vertices
interpolation.m	interpolation the boundaries to make it smooth
knee.avi	movie that contains key frames
localizeframes.m	find out the key frames from a movie
mirror.m	generate second half of the cycle from reversed first cycle
Poly2Fourier.m	polygon-support Fourier transform
segmentation.m	segment the boundaries from key frames
visualization.m	generate 2DFT k-space data from vertices, reconstruct and make a phantom movie
warping.m	use dynamic time warping to aligned vertices from different contours


shortaxisPhantom folder:

main.m		main user interface, start here
data.mat	coutours segmented from key frames 
DTW.m		dynamic time warping algorithm
extending.m	generate some fake cycles from segmented data
ift.m		inverse Fourier transform
im2eightbit.m	image resize to 0-255
increasetempres.m	increase temporal resolution of the vertices
interpolation.m	interpolation the boundaries to make it smooth
localizeframes.m	find out the key frames from a movie
Poly2Fourier.m	polygon-support Fourier transform
segmentation.m	segment the boundaries from key frames
shortaxis_ssfp.avi	movie that contains key frames
snitching.m	combine partial contours to obtain contour of region of interest
visualization.m	generate 2DFT k-space data from vertices, reconstruct and make a phantom movie
warping.m	use dynamic time warping to aligned vertices from different contours