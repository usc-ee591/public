% dispim(im,low,high)
% displays magnitude version of image im (complex array)
%

function dispim(im,low,high)

% display image
scale= 256/(high-low);
offset = scale*low;

% set colormap for 256 gray levels
a=[1 1 1]/256;
b=[1:256];
c=(a'*b)';
colormap(c);

image(abs(im)*scale-offset);
axis('square');

end

