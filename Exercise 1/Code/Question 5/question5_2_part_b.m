
% Parameters
M = 256; N = 256;                  
imageFile = 'new_york.png';        

%  Load original image and simulate blur
X0 = im2double(imread(imageFile));  
Y  = psf(X0);                      

%  Compute FFTs

delta = zeros(M,N);
delta(ceil(M/2),ceil(N/2)) = 1;
h_small = psf(delta);            

F_h = fft2(h_small, size(Y,1), size(Y,2)); 
F_Y = fft2(Y);

%  Define threshold values and preallocate MSE
T_vals = linspace(0, 0.05, 25);    
MSE    = zeros(size(T_vals));

%  Loop over thresholds
for k = 1:length(T_vals)
    T = T_vals(k);
    
    % Build inverse filter with threshold
    Hmag = abs(F_h);
    H_inv = zeros(size(F_h));
    idx = Hmag >= T;
    H_inv(idx) = 1 ./ F_h(idx);
    
    % Apply inverse filter
    X_hat = real(ifft2(F_Y .* H_inv));
    
    % Compute MSE
    MSE(k) = mean( (X0(:) - X_hat(:)).^2 );
end


figure;
plot(T_vals, MSE, '-o', 'LineWidth',1.5);
xlabel('Threshold T');
ylabel('Mean Squared Error (MSE)');
title('MSE of Inverse‐Filtered Reconstruction vs. Threshold');
grid on;

%  Find optimal threshold and reconstruct
[~, opt_idx] = min(MSE);
T_opt = T_vals(opt_idx);

% Reconstruct with optimal T
Hmag = abs(F_h);
H_inv_opt = zeros(size(F_h));
idx_opt = Hmag >= T_opt;
H_inv_opt(idx_opt) = 1 ./ F_h(idx_opt);
X_hat_opt = real(ifft2(F_Y .* H_inv_opt));


figure;
subplot(1,2,1);
imagesc(Y);
axis image off;
colormap gray;
title('Blurred Image Y');

subplot(1,2,2);
imagesc(X_hat_opt);
axis image off;
colormap gray;
title(['Deblurred Image (T = ' num2str(T_opt, '%.4f') ')']);
