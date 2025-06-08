% ---------- Part A, Method 2: Wiener assuming unknown noise power ----------

% 1. Read and convert the image to double precision
I = im2double(imread('new_york.png'));

% 2. Compute signal variance and set noise variance for SNR = 10 dB
signalVar = var(I(:));        % signal power (variance of all pixels)
SNR_dB   = 10;                
SNR       = 10^(SNR_dB/10);   % linear SNR
noiseVar  = signalVar / SNR;  % required noise variance

% 3. Add zero-mean Gaussian noise
noisy = imnoise(I, 'gaussian', 0, noiseVar);

% 4. Denoise with Wiener filter WITHOUT giving noiseVar (it will estimate it)
windowSize = [5 5];           % local window size for Wiener
filtered_est = wiener2(noisy, windowSize);

% 5. Display: original & noisy on top row, Wiener result on bottom row
figure;
subplot(2,2,1), imshow(I),            title('Original Image');
subplot(2,2,2), imshow(noisy),        title(sprintf('Noisy (SNR = %d dB)', SNR_dB));
subplot(2,2,[3 4]), imshow(filtered_est);
title('Wiener Filter (noise variance unknown)');
