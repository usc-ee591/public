%RF Tool Assignment
% It requires rf tools package and its addition to matlab working directory
close all; clear all;

N = 160;
rf = msinc(N, 1);
sum(rf)
figure; cplot(rf); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');
rf = msinc(N, 2);
sum(rf)
hold on; cplot(rf); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');
rf = msinc(N, 3);
sum(rf)
hold on; cplot(rf); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');

legend('TBW = 4', 'Zero line Reference', 'TBW = 8', 'TBW = 12');

N = 160;
rf = msinc(N, 1);
rfs = rfscale(rf,1)/4.258;
sum(rf)
figure; cplot(rfs); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');
rf = msinc(N, 2);
rfs = rfscale(rf,1)/4.2580;
sum(rf)
hold on; cplot(rfs); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');
rf = msinc(N, 3);
rfs = rfscale(rf,1)/4.2580;
sum(rf);
hold on; cplot(rfs); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');


N = 160;
rf = (pi/2)*msinc(N, 1);
rfs = rfscale(rf,1)/4.258;
sum(rf)
figure; cplot(rfs); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude, Gauss');
rf = (pi/2)*msinc(N, 2);
rfs = rfscale(rf,1)/4.2580;
sum(rf)
hold on; cplot(rfs); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude, Gauss');
rf = (pi/2)*msinc(N, 3);
rfs = rfscale(rf,1)/4.2580;
sum(rf);
hold on; cplot(rfs); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude, Gauss');
legend('TBW = 4', 'Zero line Reference', 'TBW = 8', 'TBW = 12');
close all;

x = -10:20/N:10;
rf = msinc(N, 2);
figure; plot(gt2cm(x,0.6,1), abs(ab2ex(abr(rf,x))));ylabel('Amplitude'), xlabel('Position, cm');


max(rfscale((pi/2)*msinc(N, 4),6)/4.2580)

x = -10:20/N:10;
rf = (pi/2)*msinc(N, 4);
figure; plot(gt2cm(x,0.083,6), abs(ab2ex(abr(rf,x))));ylabel('Amplitude'), xlabel('Position, cm');

N = 256;
x = -10:20/N:10;
rf = dzrf(N, 3.4, 'se','ls',0.001/4,sqrt(0.001),1.5);
rfs = rfscale(rf,3.4)/4.258;
time = 1:2.4/256:3.4;
figure; cplot(time(1:1:end-1), rfs); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude, Gauss');
figure; plot(gt2cm(x,0.42,3.4), (ab2se(abr(rf,x))));ylabel('Magnetization, Mxy'), xlabel('Position, cm');

%figure; plot(gt2cm(x,0.42,3.4), (ab2ex(abr(rf,x))));ylabel('Magnetization, Mxy'), xlabel('Position, cm');


x = -10:20/256:10;
rf = dzrf(256, 3.4, 'inv','ls',0.001/4,sqrt(0.001),1.5);
rfs = rfscale(rf,3.4)/4.258;
time = 1:2.4/256:3.4;
figure; cplot(time(1:1:end-1), rfs); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude, Gauss');
figure; plot(gt2cm(x,0.42,3.4), (ab2se(abr(rf,x))));ylabel('Magnetization, Mxy'), xlabel('Position, cm');



N = 256;
x = -10:20/N:10;
rf = dzrf(N, 3.4, 'se');
rfs = rfscale(rf,3.4)/4.258;
time = 1:2.4/256:3.4;
figure; cplot(time(1:1:end-1), rfs); title('Spin Echo RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude, Gauss');
figure; plot(gt2cm(x,0.42,3.4), (ab2se(abr(rf,x))));ylabel('Magnetization, Mxy'), xlabel('Position, cm'); title('Spin Echo Profile');

%figure; plot(gt2cm(x,0.2114,3.4), (ab2ex(abr(rf,x))));ylabel('Magnetization, Mxy'), xlabel('Position, cm');


x = -10:20/256:10;
rf = dzrf(N, 3.4, 'inv');
rfs = rfscale(rf,3.4)/4.258;
time = 1:2.4/256:3.4;
figure; cplot(time(1:1:end-1), rfs); title('Inversion RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude, Gauss');
figure; plot(gt2cm(x,0.42,3.4), (ab2inv(abr(rf,x))));ylabel('Magnetization, Mz'), xlabel('Position, cm'); title('Inversion Profile');


%figure; plot(gt2cm(x,0.42,3.4), (ab2ex(abr(rf,x))));ylabel('Magnetization, Mxy'), xlabel('Position, cm');



%b = dzls(256,3.4,0.001/4,sqrt(0.001);


%% Q1: 
% RF Pulse 1

 N = 64;  
 x = -10:20/N:10;                % Spatial Position vector
 rf = (pi/2)*msinc(N,2);         % Rf pulse design
 flip_angle = 180*sum(rf)/3.14;  % Flip Angle of the pulse
 [a b] = abr(rf, x);
 
% Plot RF Pulse and Excitation Profile
 figure; cplot(rf); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');
 figure; cplot(gt2cm(x, 0.5, 1),(abs(2*conj(a).*b))); title('Excitation Profile'); legend('My', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('|Mxy|');
 figure; cplot(gt2cm(x, 0.5, 1),ab2inv(a,b)); title('Slice Profile'); legend('Mz', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('Mz');
% RF pulse 2

 rf = dzrf(N, 8, 'se');
 flip_angle = 180*sum(rf)/3.14;
 [a b] = abr(rf, x);
 
 % Plot RF Pulse and Excitation Profile
 figure; cplot(rf); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');
 figure; cplot(gt2cm(x, 0.5, 1),(abs(2*conj(a).*b))); title('Excitation Profile'); legend('My', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('|Mxy|');
 figure; cplot(gt2cm(x, 0.5, 1),ab2inv(a,b)); title('Excitation Profile'); legend('Mz', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('Mz');
  
%% Q2: Gradient 
  l = length(rf);
  g = [0 ones(1,l)*2*pi/l 0];
  plot(gt2cm([x(1)+0.001 x(1:1:end-1) x(end-1)+0.001], 0.5, 1), g); title('Gradient'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('Amplitude (Gz)');

%% Q3: dzrf Question
 N = 64
% Small Tip
 rf = dzrf(N, 8, 'st');
 flip_angle = 180*sum(rf)/3.14;
 [a b] = abr(rf, x);
 % Plot RF Pulse and Excitation Profile
 figure; cplot(rf); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');
 figure; cplot(gt2cm(x, 0.5, 1),(abs(2*conj(a).*b))); title('Excitation Profile'); legend('My', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('|Mxy|');
 figure; cplot(gt2cm(x, 0.5, 1),ab2inv(a,b)); title('Slice Profile'); legend('Mz', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('Mz');

 % Excitation Pulse 
 rf = dzrf(N, 8, 'ex');
 flip_angle = 180*sum(rf)/3.14;
 [a b] = abr(rf, x);
 % Plot RF Pulse and Excitation Profile
 figure; cplot(rf); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');
 figure; cplot(gt2cm(x, 0.5, 1),(abs(2*conj(a).*b))); title('Excitation Profile'); legend('My', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('|Mxy|');
 figure; cplot(gt2cm(x, 0.5, 1),ab2inv(a,b)); title('Slice Profile'); legend('Mz', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('Mz');

 
 % Saturation Pulse 
 rf = dzrf(N, 8, 'sat');
 flip_angle = 180*sum(rf)/3.14;
 [a b] = abr(rf, x);
 % Plot RF Pulse and Excitation Profile
 figure; cplot(rf); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');
 figure; cplot(gt2cm(x, 0.5, 1),(abs(2*conj(a).*b))); title('Excitation Profile'); legend('My', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('|Mxy|');
 figure; cplot(gt2cm(x, 0.5, 1),ab2inv(a,b)); title('Slice Profile'); legend('Mz', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('Mz');

 %% Q4: 
 rf = dzrf(N, 8, 'inv', 'ls', 0.05, 0.001);
 flip_angle = 180*sum(rf)/3.14;
 [a b] = abr(rf, x);
 % Plot RF Pulse and Excitation Profile
 figure; cplot(rf); title('RF Pulse'); xlabel('Time (ms)'); ylabel('Amplitude');
 figure; cplot(gt2cm(x, 0.5, 1),(abs(2*conj(a).*b))); title('Excitation Profile'); legend('My', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('|Mxy|');
 figure; cplot(gt2cm(x, 0.5, 1),ab2inv(a,b)); title('Slice Profile'); legend('Mz', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('Mz');

 %% Q5:
 N = 200;
 x = -10:20/N:10;                % Spatial Position vector
 gv = 2*pi/N*[[1:50]/50 ones(1,100) [50:-1:1]/50];
 rf = dzrf(N, 8, 'st', 'ms');
 rfv = verse(gv, rf(1:100));
 t = 1/size(rfv,1):1/size(rfv,1):1;
 plot(t, rfv, t, gv, 'LineWidth', 3);
 figure; cplot(gt2cm(x, 0.5, 1), abs(ab2ex(abr(rfv, x)))); title('Excitation Profile'); legend('My', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('|Mxy|');
 figure; cplot(gt2cm(x, 0.5, 1), (ab2inv(abr(rfv, x)))); title('Slice Profile'); legend('My', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('|Mxy|');
 
 rfv = verse(gv, rf(1:150));
 t = 1/size(rfv,1):1/size(rfv,1):1;
 plot(t, rfv, t, gv, 'LineWidth', 3);
 figure; cplot(gt2cm(x, 0.5, 1), abs(ab2ex(abr(rfv, x)))); title('Excitation Profile'); legend('My', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('|Mxy|');
 figure; cplot(gt2cm(x, 0.5, 1), (ab2inv(abr(rfv, x)))); title('Slice Profile'); legend('My', 'Mx'); xlabel('Position, cm for 0.5 G/cm Gradient'); ylabel('|Mxy|');