
%  Read the image 
I = imread('hallway.png');
if size(I,3) == 3
    I = rgb2gray(I);
end
I = im2double(I);

%  Define the Sobel kernels
Sx = [-1 0 1; -2 0 2; -1 0 1];
Sy = Sx';

%  Filter to get horizontal and vertical gradients
Gx = imfilter(I, Sx, 'replicate', 'conv');
Gy = imfilter(I, Sy, 'replicate', 'conv');

%  Compute gradient magnitude
Gmag = sqrt(Gx.^2 + Gy.^2);

%  Choose one global threshold with Otsu method
level = graythresh(Gmag);
fprintf('Otsu threshold for |∇I|: %.3f\n', level);

%  Binarize the gradient magnitude
BW = imbinarize(Gmag, level);


figure('Name','Sobel + Threshold on Gradient Magnitude','NumberTitle','off');
subplot(1,2,1)
imshow(Gmag, [])
title('|∇I| (gradient magnitude)')

subplot(1,2,2)
imshow(BW)
title(sprintf('Edge map (|∇I| > %.3f)', level))
