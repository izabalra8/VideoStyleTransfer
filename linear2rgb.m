function result = linear2rgb(image)

bin=image<0.018;

image(bin)=(image(bin)).*4.5;
image(~bin)=1.099*(image(~bin).^0.45)-0.099;

result=image;
