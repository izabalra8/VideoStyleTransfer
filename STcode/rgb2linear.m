function result= rgb2linear(image)
%"Digital video and HD" formula:
image=im2double(image);
bin=image>=0.081;

image(bin)=(((image(bin))+0.099)./1.099).^(1/0.45);
image(~bin)=(image(~bin))./4.5;

result=image;