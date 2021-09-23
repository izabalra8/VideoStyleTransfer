function [result] = inverseTM(PWN,pow, image)

length = size(image(:,:,1), 2);
width = size(image(:,:,1), 1);

result=zeros(width, length, 3);

for i=1:length   
    for j=1:width
        for k=1:3
                result(j,i,k)=max(find(PWN<=image(j,i,k)));
        end
    end
end


result=result./2^pow;