function C = mydct2(P)
% 2-D��ɢ���ұ任
% �������P ����任�������C
N = size(P,1);
% ���ݹ�ʽ����任����D
D = (1:2:2*N-1).*(0:1:N-1)';
D = cos(D*pi/(2*N));
D(1,:)=sqrt(0.5);
D = D*sqrt(2/N);
% ����任���
C = D*P*D';
end

