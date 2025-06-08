
%  Inverse DFT
g_ideal    = ifft2(F_filtered_ideal);
g_gaussian = ifft2(F_filtered_gaussian);


figure('Position',[100 100 800 350]);

subplot(1,2,1);
imshow(real(g_ideal), []);
title('Spatial Domain (Ideal LPF)','FontSize',12);

subplot(1,2,2);
imshow(real(g_gaussian), []);
title('Spatial Domain (Gaussian LPF)','FontSize',12);
