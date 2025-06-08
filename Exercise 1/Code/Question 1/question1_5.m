
%  Inverse DFT
g_ideal_mod    = ifft2(F_filtered_ideal);
g_gauss_mod    = ifft2(F_filtered_gaussian);

%  Undo centering modulation
[M, N] = size(g_ideal_mod);
[x, y] = meshgrid(0:N-1, 0:M-1);
g_ideal  = real( g_ideal_mod  .* ((-1).^(x+y)) );
g_gauss  = real( g_gauss_mod  .* ((-1).^(x+y)) );


figure('Position',[100 100 800 350]);
subplot(1,2,1);
imshow(g_ideal, []);
title('Restored Image (Ideal LPF)','FontSize',12);

subplot(1,2,2);
imshow(g_gauss, []);
title('Restored Image (Gaussian LPF)','FontSize',12);
