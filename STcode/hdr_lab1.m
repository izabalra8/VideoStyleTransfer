function image = hdr_lab1(index,meanI,n)
%% semi saturation computed according to van Norren 
%muX = sqrt(mean(hdr_img(:)))*sqrt(median(hdr_img(:)));
muX = exp(meanI);
%muX = meanI;
image = fun_f(index,muX,n);
end

function out = fun_f(w,Is,n)
%n = 0.5;
out = ((w.^n)./((w.^n)+(Is^n)));%+w.^1.88;
%out = ((w.^0.61)./((w.^0.61)+(Is^0.61)));
end