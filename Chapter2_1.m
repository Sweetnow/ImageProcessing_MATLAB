clear; close all; clc;
% ��������
load('hall.mat');
target = hall_gray(1:8,1:8);  % ѡȡ���ں������������
% ֱ�Ӽ�ȥ128�Ľ��
preprocess1 = target - 128;
disp(preprocess1);
% �任����
C = mydct2(double(target));  % ʹ���˿⺯��double��unit8תΪ���ڼ����double
C(1,1) = C(1,1)-128*size(target,2); % �޸�ֱ������ʵ�ֿ����ȥ128��Ч��
preprocess2 = uint8(myidct2(C)); % ��ԭ������
disp(preprocess1);