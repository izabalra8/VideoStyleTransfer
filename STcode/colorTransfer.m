function result = colorTransfer(source, rgb_s, mean_s, mean_t, U_s, A_s, U_t, A_t)

U_t1=findRotation(U_s, U_t);

rgbh_s = [rgb_s;ones(1,size(rgb_s,2))];

% compute transforms
% translations
T_t = eye(4); T_t(1:3,4) = mean_t;
T_s = eye(4); T_s(1:3,4) = -mean_s;
% rotations
R_t = blkdiag(U_t1,1);
R_s = blkdiag(inv(U_s),1);
% scalings
S_t = diag([diag(A_t).^(0.5);1]);
S_s = diag([(diag(A_s).^(-0.5));1]);

%S_tLUM = eye(4); S_tLUM(:,1)=S_t(:,1);
S_tHUE = eye(4); S_tHUE(:,2:3)=S_t(:,2:3);

%S_sLUM = eye(4); S_sLUM(:,1)=S_s(:,1);
S_sHUE = eye(4); S_sHUE(:,2:3)=S_s(:,2:3);

rgbh_e = T_t*R_t*S_tHUE*S_sHUE*R_s*T_s*rgbh_s;  % estimated RGBs
rgbh_e = bsxfun(@rdivide, rgbh_e, rgbh_e(4,:));
rgb_e = rgbh_e(1:3,:);


result = reshape(rgb_e',size(source));

end