
% Load the image
S = load('tiger.mat');
if isfield(S,'I')
    I = S.I;
elseif isfield(S,'tiger')
    I = S.tiger;
else
    error('Unexpected variable name in tiger.mat');
end

% Convert to double and normalize to [0,1] for imnoise
I  = double(I);
I_norm = mat2gray(I);   

%  Add 20% salt-and-pepper noise
amount = 0.20;  
I_sp = imnoise(I_norm, 'salt & pepper', amount);


numCorrupted = sum(I_sp(:)==0 | I_sp(:)==1);
fprintf('Actual noise ratio: %.2f%% (target: 20%%)\n', 100 * numCorrupted/numel(I_sp));

%  Apply a 3×3 moving‐average filter
h_avg = fspecial('average',[3 3]);
I_avg = imfilter(I_sp, h_avg, 'replicate');

%  Apply a 3×3 median filter
I_med = medfilt2(I_sp, [3 3]);


figure('Position',[100 100 800 600]);

subplot(2,2,1)
imshow(I_norm,[])
title('Original (normalized)')

subplot(2,2,2)
imshow(I_sp,[])
title(sprintf('Salt-&-Pepper (20%%) — actual %.1f%%',100*numCorrupted/numel(I_sp)))

subplot(2,2,3)
imshow(I_avg,[])
title('Moving-Average Filter (3×3)')

subplot(2,2,4)
imshow(I_med,[])
title('Median Filter (3×3)')

%  Compute and print output SNRs
snr_avg = 10*log10( mean(I_norm(:).^2) / mean((I_avg(:)-I_norm(:)).^2) );
snr_med = 10*log10( mean(I_norm(:).^2) / mean((I_med(:)-I_norm(:)).^2) );
fprintf('Output SNR (moving average): %.2f dB\n', snr_avg);
fprintf('Output SNR (median):         %.2f dB\n', snr_med);
