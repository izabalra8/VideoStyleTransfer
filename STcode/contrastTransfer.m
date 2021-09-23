function [result, sigmaLocal] = contrastTransfer(source, target)

rgb_s = reshape(im2double(source),[],3)';
rgb_t = reshape(im2double(target),[],3)';
% compute mean
mean_s = mean(rgb_s,2);
mean_t = mean(rgb_t,2);

% compute covariance
cov_s = cov(rgb_s');
cov_t = cov(rgb_t');

% decompose covariances
[U_s,A_s,~] = svd(cov_s);
[U_t,A_t,~] = svd(cov_t);

rgbh_s = [rgb_s;ones(1,size(rgb_s,2))];

rgbh_t = [rgb_t;ones(1,size(rgb_t,2))];

% translations
 T_sINV = eye(4); T_sINV(1:3,4) = -mean_s;
 T_s = eye(4); T_s(1:3,4) = mean_s;
 

T_tINV = eye(4); T_tINV(1:3,4) = -mean_t;
T_t = eye(4); T_t(1:3,4) = mean_t;

 
% rotations
R_sINV = blkdiag(inv(U_s),1);
R_s = blkdiag(U_s,1);

%In case the first axis is the oposite
R_180z=[-1 0 0 0; 0 -1 0 0; 0 0 1 0; 0 0 0 1];
R_180zINV= inv(R_180z);

R_tINV = blkdiag(inv(U_t),1);
R_t = blkdiag(U_t,1);


% From RGB image, extract the luminance channel according to PCA (first
% axis):
% 1. translate to origin, 2. rotate to the principal component, 3. translate 
% back to the original position and 4. extract the first channel.

rgbh_e = T_s*R_180z*R_sINV*T_sINV*rgbh_s;

rgbh_e = bsxfun(@rdivide, rgbh_e, rgbh_e(4,:));
rgb_e = rgbh_e(1:3,:);
source_rotated = reshape(rgb_e',size(source));
sourceLuminance=source_rotated(:,:,1);

rgbh_et = T_t*R_180z*R_tINV*T_tINV*rgbh_t;

rgbh_et = bsxfun(@rdivide, rgbh_et, rgbh_et(4,:));
rgb_et = rgbh_et(1:3,:);
target_rotated = reshape(rgb_et',size(target));
targetLuminance=target_rotated(:,:,1);

%contrast normalization
meanSource=localMean(sourceLuminance);
contrastSource=sourceLuminance-meanSource;

meanTarget=localMean(targetLuminance);
contrastTarget=targetLuminance-meanTarget;

sigmaLocal=std2(contrastTarget)/std2(contrastSource);

resultLuminanceLocal=meanSource+contrastSource*sigmaLocal;
source_rotated(:,:,1)=resultLuminanceLocal;


%Undo rotations and translations to get the RGB image
rgb_sr = reshape(im2double(source_rotated),[],3)';

rgbh_sr = [rgb_sr;ones(1,size(rgb_sr,2))];

rgbh_er = T_s*R_s*R_180zINV*T_sINV*rgbh_sr;

rgbh_er = bsxfun(@rdivide, rgbh_er, rgbh_er(4,:));
rgb_er = rgbh_er(1:3,:);

result = reshape(rgb_er',size(source));



