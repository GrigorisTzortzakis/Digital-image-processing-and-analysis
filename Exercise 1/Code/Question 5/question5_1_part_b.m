
% compute the impulse response h
M = 256; N = 256;                  
delta = zeros(M, N);
delta(ceil(M/2), ceil(N/2)) = 1;   
h = psf(delta);                    

% Display the spatial-domain impulse response
figure;
imagesc(h);
axis image off;
colormap gray;
title('Spatial Impulse Response h(x,y)');



H = fftshift( fft2(h) );        
Mag = abs(H);

figure;
imagesc(log(1 + Mag));            
axis image off;
colormap jet;
title('Log-Magnitude Frequency Response |H(u,v)|_{log}');
