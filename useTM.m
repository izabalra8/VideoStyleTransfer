function [TM]=useTM(PWN, pow, HDR_in)

iGRAY_R = 1+ceil( HDR_in(:,:,1) .* ((2^pow)-1) ); %pow = camerabitrate 
iGRAY_G = 1+ceil( HDR_in(:,:,2) .* ((2^pow)-1) );
iGRAY_B = 1+ceil( HDR_in(:,:,3) .* ((2^pow)-1) );
           
           
TM_R = (PWN(iGRAY_R));
TM_G = (PWN(iGRAY_G));
TM_B = (PWN(iGRAY_B));

TM(:,:,1)=TM_R;
TM(:,:,2)=TM_G;
TM(:,:,3)=TM_B;
