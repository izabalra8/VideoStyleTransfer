function [Rt1] = findRotation(Rs, Rt)
%given the axis Rs, and Rt, find the closest rotation between them

dim=size(Rs, 1);

Rt1=zeros(dim);

for i=1:size(Rs, 2)
    selected=[];
    angle=pi;
    position=0;
    for j=1:size(Rt,2)
        %calculate angle between axis
        a=acos(dot(Rs(:,i), Rt(:,j))/(norm(Rs(:,i))*norm(Rt(:,j))));
        if(a<=angle)
            angle=a;
            selected=Rt(:,j);
            position=j;
        end
        %check if the opposite direction is closer
        a=acos(dot(Rs(:,i)*(-1), Rt(:,j)/(norm(Rs(:,i))*norm(Rt(:,j)))));
        if(a<=angle)
            angle=a;
            selected=Rt(:,j)*(-1);
            position=j;
        end
    end
    Rt1(:, i)=selected;
    Rt(:, position)=[];
end