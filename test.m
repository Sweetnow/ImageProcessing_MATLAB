function v = pic2vec(RGB,L)
% pic2vec �������RGBͼ��ת��Ϊ��������v����ɫλ����L����
L_pic = int32(bitshift(RGB,L-8)); % ��ȡ��ɫ�ĸ�Lλ
color = bitshift(L_pic(:,:,1),2*L)+bitshift(L_pic(:,:,2),L)+L_pic(:,:,3);   % ƴ��RGB������ɫ�ĸ�Lλ
color = color(:);   % չƽ
 v = zeros(2^(3*L),1);    % ����Ϊ2^(3L)
for m=1:length(color)
    v(color(m)+1) = v(color(m)+1)+1;  % ��ÿ����ɫ�ֱ����
end
v = v/length(color);    % ��һ��
end