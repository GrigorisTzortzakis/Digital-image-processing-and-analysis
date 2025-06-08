
%  Load the  image
S = load('tiger.mat');
if isfield(S,'I')
    I = S.I;
elseif isfield(S,'tiger')
    I = S.tiger;
else
    error('Unexpected variable name in tiger.mat');
end

% Convert to double
I = double(I);

%  Compute noise variance for target SNR
SNRdB     = 15;                        
P_signal  = mean(I(:).^2);            
P_noise   = P_signal / (10^(SNRdB/10));
sigma     = sqrt(P_noise);            

% Add zero‐mean Gaussian noise
rng(0);  
I_noisy = I + sigma * randn(size(I));


snr_noisy = 10*log10( mean(I(:).^2) / mean((I_noisy(:)-I(:)).^2) );
fprintf('Noisy-image SNR: %.2f dB (target: %d dB)\n', snr_noisy, SNRdB);

% Moving‐average filter (3×3)
h_avg = fspecial('average',[3 3]);
I_avg = imfilter(I_noisy, h_avg, 'replicate');

%  Median filter (3×3)
I_med = medfilt2(I_noisy, [3 3]);


figure('Position',[100 100 800 600]);

subplot(2,2,1)
imshow(I,[])        
title('Original')

subplot(2,2,2)
imshow(I_noisy,[])
title(sprintf('Noisy (15 dB) — \\sigma=%.3f',sigma))

subplot(2,2,3)
imshow(I_avg,[])
title('Moving‐Average Filter (3×3)')

subplot(2,2,4)
imshow(I_med,[])
title('Median Filter (3×3)')

%  Compute output SNRs after filtering
snr_avg = 10*log10( mean(I(:).^2) / mean((I_avg(:)-I(:)).^2) );
snr_med = 10*log10( mean(I(:).^2) / mean((I_med(:)-I(:)).^2) );
fprintf('Output SNR (moving average): %.2f dB\n', snr_avg);
fprintf('Output SNR (median):         %.2f dB\n', snr_med);
