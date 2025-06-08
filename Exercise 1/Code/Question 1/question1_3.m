
% Create frequency coordinates
[M, N] = size(F2);
[u, v] = meshgrid(0:N-1, 0:M-1);
u_centered = u - N/2;
v_centered = v - M/2;

% Distance from center
D = sqrt(u_centered.^2 + v_centered.^2);

% Choose cutoff frequency
cutoff_freq = 30;  

% Ideal Low-Pass Filter
H_ideal = double(D <= cutoff_freq);


F_filtered_ideal = F2 .* H_ideal;

% Gaussian Low-Pass Filter
sigma = cutoff_freq / 3;
H_gaussian = exp(-(D.^2) / (2*sigma^2));


F_filtered_gaussian = F2 .* H_gaussian;


figure('Position', [100 100 1000 600]);


subplot(2,3,1);
imshow(H_ideal, []);
title(sprintf('Ideal LPF (cutoff=%d)', cutoff_freq), 'FontSize', 12);

subplot(2,3,2);
imshow(log(1 + abs(F_filtered_ideal)), []);
title('Filtered Spectrum (Ideal)', 'FontSize', 12);


subplot(2,3,3);
imshow(log(1 + abs(F2 - F_filtered_ideal)), []);
title('Removed Frequencies (Ideal)', 'FontSize', 12);


subplot(2,3,4);
imshow(H_gaussian, []);
title(sprintf('Gaussian LPF (σ=%0.1f)', sigma), 'FontSize', 12);


subplot(2,3,5);
imshow(log(1 + abs(F_filtered_gaussian)), []);
title('Filtered Spectrum (Gaussian)', 'FontSize', 12);


subplot(2,3,6);
imshow(log(1 + abs(F2 - F_filtered_gaussian)), []);
title('Removed Frequencies (Gaussian)', 'FontSize', 12);