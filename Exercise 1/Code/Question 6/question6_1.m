
% 1. Read image and convert to grayscale
I = imread('hallway.png');
if size(I,3)==3
    Igray = rgb2gray(I);
else
    Igray = I;
end
Igray = im2double(Igray);

%  Define Sobel masks
Sx = [ -1  0  1;
       -2  0  2;
       -1  0  1 ];   
Sy = Sx';             

%  Convolve to get gradient components
Gx = imfilter(Igray, Sx, 'replicate', 'conv');
Gy = imfilter(Igray, Sy, 'replicate', 'conv');

%  Compute gradient magnitude
Gmag = sqrt(Gx.^2 + Gy.^2);


figure('Name','Sobel Edge Detection','NumberTitle','off','Position',[100 100 900 300])
subplot(1,3,1)
imshow(Gx,[])
title('G_x (horizontal edges)')

subplot(1,3,2)
imshow(Gy,[])
title('G_y (vertical edges)')

subplot(1,3,3)
imshow(Gmag,[])
title('|\nabla I| (edge strength)')
colormap(gca,'gray')
