function [TM, PWN] = testTM(image, ISOspeed, bitrate)

%camera bit rate (10 mobile phone, 12 normal DSLR cameras, 14 best DSLR cameras)
%image is the linear image
%200 ISO

ISO=ISOspeed;
camerabitrate=bitrate; 

length = size(image(:,:,1), 2);
width = size(image(:,:,1), 1);

image=im2double(image);

lumIMAGE=zeros(width, length);

for i=1:length
    for j=1:width
        lumIMAGE(j,i)=0.2126729*double(image(j,i,1))+0.7151522*double(image(j,i,2))+0.0721750*double(image(j,i,3));
    end
end


N=length*width;

PWN=TMO_ours_trimmean_raw(lumIMAGE,N,0,0,camerabitrate, ISO);

TM=useTM(PWN, camerabitrate, image);   
