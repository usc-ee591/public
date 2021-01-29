function [] = display_Image(im, func)
% Input:   Image im
%           func which can take values 1 for absolute, 2 for
%           real and 3 for imaginary. If not specified then abs values are
%           plotted, if incorrectly specified then it displays an error
%           message.
           

% This function plots the images with proper image scaling and colorbar. 
if isempty(func) == 1
    figure; imagesc(abs(im)); axis image; colormap gray; axis off; colorbar; %title(fprintf('%s',title));
else
    if func == 1 
        figure; imagesc(abs(im)); axis image; colormap gray; axis off; colorbar; %title(fprintf('%s',title));
    end
    if func == 2 
        figure; imagesc(re(im)); axis image; colormap gray; axis off; colorbar; %title(fprintf('%s',title));
    end
    if func == 3 
        figure; imagesc(re(im)); axis image; colormap gray; axis off; colorbar; %title(fprintf('%s',title));
    end
    if func ~= 1  && func ~= 2 && func ~= 3 
        fprintf('This function cannot be plotted for the speciifed images');
    end
end
end