function mean = localMean(image)
% calculates de local contrast function as: 
%               I-mu
% where I is luminance image and mu is the *local mean* of the image
% calculate mu by convolution of G and I
% where G is sum of two gaussians

%calculate the filter : sum of two gaussians
filtersize=min(size(image(:,:,1)));
G1 = fspecial('gaussian', filtersize, filtersize/4);
G2 = fspecial('gaussian', filtersize, filtersize/16);
G=0.5*G1+0.5*G2;
% figure
% plot(G(floor(size(G,1)/2), :));

% padding of filter
G3=zeros(size(image));
a=floor(size(G3, 1)./2 - filtersize/2)+1;
b=floor(size(G3,1)./2 + filtersize/2);
c=floor(size(G3, 2)./2 - filtersize/2)+1;
d=floor(size(G3,2)./2 + filtersize/2);
G3(a:b, c:d)=G;
a2=fftshift(fft2(G3));

% convolution between image and sum of gaussians
a1=fftshift(fft2(image));
mean= abs(ifftshift(ifft2(a1.*a2)));

