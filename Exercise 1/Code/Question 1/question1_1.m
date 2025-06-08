%  Load image 
I = imread('moon.jpg');
if size(I,3) == 3
    I = rgb2gray(I);
end
I = double(I);

% Linear stretch to full  range
minVal = min(I(:));
maxVal = max(I(:));
I_stretched = 255 * (I - minVal) / (maxVal - minVal);

%  Modulate image with (-1)^(x+y) to shift zero-frequency to center
[M, N] = size(I_stretched);
[x, y] = meshgrid(0:N-1, 0:M-1);
I_mod = I_stretched .* ((-1) .^ (x + y));

%  Compute 2D DFT of modulated image
F_centered = fft2(I_mod);

 
figure('Position',[100 100 900 350]);

subplot(1,3,1);
imshow(uint8(I));
title('Original Grayscale','FontSize',12);

subplot(1,3,2);
imshow(uint8(I_stretched));
title('Stretched [0–255]','FontSize',12);

subplot(1,3,3);
imshow(log(1 + abs(F_centered)), []);
title('Centered DFT (Log Magnitude)','FontSize',12);


figure('Position',[100 100 800 300]);

subplot(1,2,1);
imhist(uint8(I), 256);
xlim([0 255]);
title('Histogram of Original','FontSize',12);
xlabel('Intensity');
ylabel('Frequency');

subplot(1,2,2);
imhist(uint8(I_stretched), 256);
xlim([0 255]);
title('Histogram of Stretched','FontSize',12);
xlabel('Intensity');
ylabel('Frequency');