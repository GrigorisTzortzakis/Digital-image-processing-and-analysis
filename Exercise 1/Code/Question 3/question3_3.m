
% Load the  image
S = load('tiger.mat');
if isfield(S,'I')
    I = S.I;
elseif isfield(S,'tiger')
    I = S.tiger;
else
    error('Unexpected variable name in tiger.mat');
end
I = double(I);                % convert to double

%  Add Gaussian noise @15 dB SNR
SNRdB    = 15;
P_signal = mean(I(:).^2);
P_noise  = P_signal / (10^(SNRdB/10));
sigma    = sqrt(P_noise);
rng(0);                        % for reproducibility
I_gauss  = I + sigma*randn(size(I));


snr_gauss = 10*log10( mean(I(:).^2) / mean((I_gauss(:)-I(:)).^2) );
fprintf('Gaussian-only SNR: %.2f dB (target %d dB)\n', snr_gauss, SNRdB);

% Add 20% salt-&-pepper noise
I_norm      = mat2gray(I_gauss);      
amount      = 0.20;
I_mixed     = imnoise(I_norm,'salt & pepper',amount);

% Verify actual impulsive ratio
impulses = sum(I_mixed(:)==0 | I_mixed(:)==1);
actual_pct = 100 * impulses/numel(I_mixed);
fprintf('Salt–&–pepper ratio: %.2f%% (target 20%%)\n', actual_pct);

% Denoising: Median → Moving‐Average
%  3×3 median
I_med = medfilt2(I_mixed, [3 3]);

%  3×3 moving‐average
h_avg = fspecial('average',[3 3]);
I_out = imfilter(I_med, h_avg, 'replicate');


figure('Position',[100 100 900 700]);

subplot(2,2,1)
imshow(I,[]) 
title('Original')

subplot(2,2,2)
imshow(I_mixed,[])
title(sprintf('Mixed Noise\n(Gauss @15 dB + 20%% S&P)'))

subplot(2,2,3)
imshow(I_med,[])
title('After Median (3×3)')

subplot(2,2,4)
imshow(I_out,[])
title('Then Moving-Average (3×3)')

% Compute and print final SNR
snr_out = 10*log10( mean(I(:).^2) / mean((I_out(:)-I(:)).^2) );
fprintf('Final output SNR: %.2f dB\n', snr_out);
