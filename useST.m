function CMCN = useST(source, ref)

source=im2double(source);
source(source>1)=1;
source(source<0)=0;

ref=im2double(ref);
ref(ref>1)=1;
ref(ref<0)=0;

[TMs, ~]=testTM(source, 200, 12);

[~, PWNt]=testTM(rgb2linear(ref), 200, 10);
 
% Luminance transferred image TM
TM=linear2rgb(inverseTM(PWNt, 10, TMs));

rgb_s = reshape(im2double(TM),[],3)';
rgb_t = reshape(im2double(ref),[],3)';

% compute mean
mean_s = mean(rgb_s,2);
mean_t = mean(rgb_t,2);

% compute covariance
cov_s = cov(rgb_s');
cov_t = cov(rgb_t');

% decompose covariances
[U_s,A_s,~] = svd(cov_s);
[U_t,A_t,~] = svd(cov_t);

% color transferred image CM
CM=colorTransfer(TM, rgb_s, mean_s, mean_t, U_s, A_s, U_t, A_t);

% contrast transferred image CMCN
CMCN=contrastTransfer(CM, ref);


