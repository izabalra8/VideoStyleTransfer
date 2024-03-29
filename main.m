function main()
%   main() generates a style transfered image according to the style of a reference image.
%
%   -sourceRAW- is a RAW (demosaiced, whitebalanced) linear image, -ref- is a
%   gamma corrected image (jpeg, png, etc).

%   References:
%   I. Zabaleta and M. Bertalmio, "Photorealistic Style Transfer for 
%   Video" % In Signal Processing: Image Communication, 2021.
%
%   I. Zabaleta and M. Bertalmio, "Photorealistic Style Transfer for 
%   Cinema Shoots" % In Proceedings of Colour and Visual Computing 
%   Symposium (CVCS), 2018.
% 
%   This code is property of Universitat Pompeu Fabra. 

sourceRAW=imread('img\source.jpg');
ref=imread('img\ref.jpg');

result = useST(sourceRAW, ref);

imwrite(result, 'img/results/result.jpg', 'Quality', 100);
