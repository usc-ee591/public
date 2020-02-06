%	Magnetic Resonance Imaging Demo
%	To run it, type mrdemo at the >> prompt.

%	written by Dwight Nishimura May 1995

echo on
clc
%	RAW DATA FROM A 2DFT BRAIN SCAN
%
%	This is raw data from a T1-weighted spin-echo brain scan of an 
%	axial slice.
%	As before, we acquired 256 phase encodes with each readout signal
%	sampled to 256 points.

load headrawdata;
figure(1)
dispim(headraw,-75,8314/75);
title('Raw Data (2DFT Brain Scan)');
ylabel('kx');
xlabel('ky');

pause	% Press any key to continue

clc
%	RECONSTRUCTED IMAGE
%
%	Here is the reconstructed image obtained by inverse 2D FFT.
%	The bright outer layer is subcutaneous fat.
%	Contrast can be seen between gray matter (outer part of brain) 
%	and white matter (inner part: higher in signal).
%	Which matter has the shorter T1?
%	The ventricles can be seen near the center (dark).
%	The small but bright circular signal near the bottom-center 
%	is a blood vessel.
%
%	The FOV = 24 cm.

figure(2)
im = reconim(headraw);	% please wait a few seconds
dispim(flipud(im),0,130600/3);
title('Magnitude Image');
ylabel('Readout Direction');
xlabel('Phase Encode Direction');

pause	% Press any key to continue

clc
%	ANSWER:  The white matter has the shorter T1 since it appears brighter 
%	than gray matter; i.e., white matter's Mz recovers more quickly.
%
%	REDUCED NUMBER OF PHASE ENCODES:  LOWER SPATIAL RESOLUTION
%
%	Let us now reduce the number of phase encodes to 64,
%	keeping the center 64.
%	Because we do not sample the high spatial frequencies in ky,
%	the spatial resolution will be poorer.
%	Here is what the raw data now looks like.

head64=truncraw(headraw,64);
figure(1)
dispim(head64,-75,8314/75);
title('Raw Data Truncated to Center 64 Phase Encodes (Brain)');
ylabel('kx');
xlabel('ky');

pause	% Press any key to continue

clc
%	RECONSTRUCTED LOWER RESOLUTION IMAGE IN PHASE-ENCODE DIRECTION
%
%	Here is the reconstructed image obtained by inverse (256x256) 2D FFT.
%	In addition to poorer resolution in the phase-encode direction,
%	the image demonstrates increased ringing due to the truncation in 
%	k-space. The general contrast is maintained however because it 
%	depends largely on the low spatial frequencies, which we still have.

im = reconim(head64);	% please wait a few seconds
dispim(flipud(im),0,92282/2.2);
title('Magnitude Image (64 phase encodes)');
ylabel('Readout Direction');
xlabel('Phase Encode Direction');

pause	% Press any key to continue

clc
%	EVEN LOWER RESOLUTION IMAGE IN PHASE-ENCODE DIRECTION
%
%	Let us severely reduce the number of phase encodes down to 32.
%	The resultant image obtained by inverse (256x256) 2D FFT shows
%	that considerable detail is now lost although, again,
%	the general contrast is maintained.

figure(2);
head32=truncraw(headraw,32);
im = reconim(head32);	% please wait a few seconds
dispim(flipud(im),0,56153/1.3);
title('Magnitude Image (32 phase encodes)');
ylabel('Readout Direction');
xlabel('Phase Encode Direction');

pause 	% Press any key to continue

clc
%	VERY LOW RESOLUTION IMAGE IN PHASE-ENCODE DIRECTION
%
%	Let us severely reduce the number of phase encodes down to 2.
%	The resultant image obtained by inverse (256x256) 2D FFT shows
%	that considerable detail is now lost although, again,
%	the general contrast is maintained.

figure(2);
head2=truncraw(headraw,2);
im = reconim(head2);	% please wait a few seconds
dispim(flipud(im),0,56153/1.3);
title('Magnitude Image (2 phase encodes)');
ylabel('Readout Direction');
xlabel('Phase Encode Direction');

pause 	% Press any key to continue

clc
%	VERY LOW RESOLUTION IMAGE IN PHASE-ENCODE DIRECTION
%
%	Let us severely reduce the number of phase encodes down to 8.
%	The resultant image obtained by inverse (256x256) 2D FFT shows
%	that considerable detail is now lost although, again,
%	the general contrast is maintained.

figure(2);
head8=truncraw(headraw,8);
im = reconim(head8);	% please wait a few seconds
dispim(flipud(im),0,56153/1.3);
title('Magnitude Image (8 phase encodes)');
ylabel('Readout Direction');
xlabel('Phase Encode Direction');

pause 	% Press any key to continue
clc
%	REDUCED PHASE ENCODES: SMALLER FIELD OF VIEW
%
%	Finally, let us consider the case in which every other phase
%	encode is acquired.  Therefore we have 128 phase encodes that span 
%	the same extent in ky as before but with twice the sampling interval.
%	In the displayed raw data, note that every other line in ky is zero.

headraw2=zerope(headraw,2);	
figure(1)
dispim(headraw2,-75,8314/75);
title('Raw Data in Which Every Other Phase Encode is Acquired (Brain)');
ylabel('kx');
xlabel('ky');

pause	% Press any key to continue

clc
%	RECONSTRUCTED IMAGE: SMALLER FIELD OF VIEW
%
%	The resultant image shows the effect of the coaser sampling interval
%	in ky.  The replication "islands" in object space are now separated
%	by half the distance as before; hence overlap due to aliasing is 
%	occurring.  In the image, only the center 128 lines in the phase-
%	encoding direction are pertinent since we had only 128 phase encodes.
%	The outer 128 object lines (64 on each side) are redundant.
%	Thus the field of view in the phase-encode direction is now 12 cm
%	instead of 24 cm.  

figure(2)
im = reconim(headraw2);
dispim(flipud(im),0,32264/1.5);
title('Magnitude Image (128 phase encodes: reduced field of view)');
ylabel('Readout Direction');
xlabel('Phase Encode Direction');

pause	% Press any key to continue

clc
%	RECONSTRUCTED IMAGE: SMALLER FIELD OF VIEW
%
%	In practice, the reconstruction computer normally accumulates 
%	the 128 phase encodes without placing lines of zeros in between.
%	Then the raw data matrix is zero-padded out to 256 x 256 and then
%	an inverse 2D FFT is taken to reconstruct the image.
%	Here is the resultant image.  Notice that the image appears
%	stretched because a smaller field of view is represented in the
%	phase encode direction.

headraw2 = centerpe(headraw,2);
im = reconim(headraw2);	% please wait a few seconds
figure(1)
dispim(flipud(im),0,32264/1.5);
title('Magnitude Image (Zero-padded reconstruction: reduced field of view)');
ylabel('Readout Direction');
xlabel('Phase Encode Direction');

%
% 	This concludes the demo.  
%

