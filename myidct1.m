function p = myidct1(c)
% 1-D��ɢ�����ұ任
% ����������p ����任���������c
N = length(c);
% ���ݹ�ʽ����任����D
D = (1:2:2*N-1).*(0:1:N-1)';
D = cos(D*pi/(2*N));
D(1,:)=sqrt(0.5);
D = D*sqrt(2/N);
% ����任���
p = D'*c;
end

