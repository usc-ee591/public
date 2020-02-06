% imout=reconim(arr)
% reconstructs image from complex array arr
%

function imout=reconim(arr)

% compute image without fermi filter
imout = fftshift(fft2(fftshift(arr)));
low=min(min(abs(imout)));
high=max(max(abs(imout)));
fprintf('min value of image is %6.0f, max value is %6.0f\n',low,high);
end

