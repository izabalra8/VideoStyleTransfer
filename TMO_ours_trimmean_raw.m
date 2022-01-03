function [PWN] =  TMO_ours_trimmean_raw(GRAY,N, DispImg, Clip,camerabitrate, ISO)
%%Ch has the (high) clipping information -> all values above 1/Ch are
%%clipped

pow   = camerabitrate;                            % set histogram resolution
logval = log10(1/2^camerabitrate);%-6 for ARRI log10(min(GRAY(GRAY>0)));%
if logval < -6
    logval = -6;
end


%% Compute the semi saturation and Gammas
GRAY = reshape(GRAY,1,N);
index = logspace(logval, 0, 2^pow );        % histogram index
li=log(index);
histo1 = hist( GRAY(:), index );
H=cumsum(histo1);
logH=log(H+1);
loghisto1 = log(histo1 + 1);

if (DispImg == 1)
    figure;
    plot(li,loghisto1);hold on;
    
    plot(li,logH);hold on;
    
    figure;
    plot(li,H/N);hold on
    title('log histogram vs. log luminance');
end
Low_x = max(li(find((logH<1.1)|(logH == min(logH(:))), 1, 'last' )),log(2/2^pow));
High_x =li(find(logH<(log(N-N/10)), 1, 'last' ));
maxx = High_x - (High_x-Low_x)/2;

mulogg = log(median(GRAY(:))) - 2;
if (mulogg < -11)
     mulogg = -11
end
maxx = mulogg;
temp = logH(find(li>mulogg, 1 ));

if (temp > log(N*18/100))
    mulogg = li(find(logH<log(N*18/100), 1, 'last' ));
    if (isempty(mulogg))
        mulogg = maxx;
    end
    
    if (mulogg < -12)
     mulogg = -12;
   end
end

maxx_gh = log(median(GRAY(:)));
maxy_gh = logH(find(li>maxx_gh, 1 ));
maxx = log(sqrt(median(GRAY(:))*trimmean(GRAY,1)));
maxy = logH(find(li>maxx, 1 ));
maxy_gh_temp = logH(find(li>(maxx_gh-0.1), 1 ));
deriv_median = (maxy_gh - maxy_gh_temp)/0.1;

if(deriv_median > 4) % jump in the cumulative histogram eg image snow
    maxx_gh = maxx_gh-0.1 ;
    maxy_gh = logH(find(li>maxx_gh, 1 ));
    minLy = logH(find(logH>(maxy_gh-1), 1 ));
    minLx =li(find(logH>minLy, 1 ));
    maxRx = 0.0;
    maxRy = max(logH(:));
    gPL = (maxy_gh-minLy)/(maxx_gh-minLx); %Gamma low
    gPH =(maxy_gh-maxRy)/(maxx_gh-maxRx) ; %Gamma high
    
else
    
    maxx_mean = log(mean(GRAY(:)));
    maxy_mean = logH(find(li>maxx_mean, 1 ));
    minLy = logH(find(logH>(maxy-1), 1 ));
    minLx =li(find(logH>minLy, 1 ));
    minLy_mean = logH(find(logH>(maxy_mean-1), 1 ));
    minLx_mean =li(find(logH>minLy_mean, 1 ));
    
    maxRx = 0.0;
    maxRy = max(logH(:));
    
    
    gPL_mean= (maxy_mean-minLy_mean)/(maxx_mean-minLx_mean); %Gamma low
    gPH_mean =(maxy_mean-maxRy)/(maxx_mean-maxRx) ; %Gamma high
    
    gPL = (maxy-minLy)/(maxx-minLx); %Gamma low
    gPH =(maxy_gh-maxRy)/(maxx_gh-maxRx) ; %Gamma high
    
    if((gPH_mean >gPH)&&(log(median(GRAY(:)))<log(mean(GRAY(:))))) % bi modal distribution
        gPL = gPL_mean;
        maxx_gh = log(median(GRAY(GRAY>median(GRAY(:)))));
        maxy_gh = logH(find(li>maxx_gh, 1 ));
        gPH =(maxy_gh-maxRy)/(maxx_gh - maxRx) ;
    end
end

if (gPL > 1)
    gPL = 1;
end

if(gPH>0.45)
    gPH = 0.45;
end

if(gPH>gPL)
    gPL = gPH;
end

m = gPL;

if (m > 1)
    m = 1;
end

index = linspace(0,1,2^pow);
Index_NR        =   hdr_lab1(index,mulogg,m);

Index_NR        =   1- Index_NR;
gP1             =   Index_NR*(gPL-gPH)+gPH;


if (Clip == 1 )
    High_x_temp =li(find(logH<(log(N-N/255)), 1, 'last' )); %% changed from 100 to 255
    Low_x_temp = li(find((logH<log(N/255))|(logH == min(logH(:))), 1, 'last' ));
    Index_NR_temp   =   hdr_lab1(index,mulogg,1);
    Ch = exp(log(1 - 1/255) + gPH * -High_x_temp);  
    Cl = exp(log(1/255) - gPL *(Low_x_temp));
    
    if (Cl  > 1 || gPL<gPH)
        Cl = 1;
    end
    
    Index_NR_temp   =   Index_NR_temp*(Ch-Cl)+Cl;
    PWN            =   index.^ (gP1).*  Index_NR_temp;
    
else
    PWN = index.^gP1;
    
end

PWN(PWN>1) = 1;

end