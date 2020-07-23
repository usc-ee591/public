%RF Tool Assignment
% It requires rf tools package and its addition to matlab working directory
close all; clear all;

%% RF Pulse 1

 N = 64;  
 x = -10:20/N:10;                % Spatial Position vector
 rf = (pi/2)*msinc(N,2);         % Rf pulse design
 flip_angle = 180*sum(rf)/3.14;  % Flip Angle of the pulse
 [a b] = abr(rf, x);
 
 % Plot RF Pulse and Excitation Profile
 figure; cplot(rf); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');
 figure; cplot(gt2cm(x, 0.5, 1),(abs(2*conj(a).*b))); title('Excitation Profile'); legend('My', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('|Mxy|');
 figure; cplot(gt2cm(x, 0.5, 1),ab2inv(a,b)); title('Excitation Profile'); legend('Mz', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('Mz');
%% RF pulse 2

 rf = dzrf(N, 8, 'se');
 flip_angle = 180*sum(rf)/3.14;
 [a b] = abr(rf, x);
 
  % Plot RF Pulse and Excitation Profile
 figure; cplot(rf); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');
 figure; cplot(gt2cm(x, 0.5, 1),(abs(2*conj(a).*b))); title('Excitation Profile'); legend('My', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('|Mxy|');
 figure; cplot(gt2cm(x, 0.5, 1),ab2inv(a,b)); title('Excitation Profile'); legend('Mz', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('Mz');
  