
% load image
I = im2double(imread('new_york.png'));

% noise level
signalVar = var(I(:));         
SNR_dB   = 10;                 
SNR       = 10^(SNR_dB/10);    
noiseVar  = signalVar / SNR;   

noisy = imnoise(I, 'gaussian', 0, noiseVar);

% wiener
windowSize = [5 5];  
filtered_known = wiener2(noisy, windowSize, noiseVar);


figure;
subplot(2,2,1), imshow(I),     title('Αρχική εικόνα');
subplot(2,2,2), imshow(noisy), title(sprintf('Θορυβώδης (SNR = %d dB)', SNR_dB));

subplot(2,2,[3 4]), imshow(filtered_known);
title('Wiener (γνωστή noiseVar)');
