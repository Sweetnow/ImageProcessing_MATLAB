clear; close all; clc;
% ��������
load('hall.mat');
start_x=100;    % Ѱ��һ���ʺϹ۲������
start_y=10;     % Ѱ��һ���ʺϹ۲������
target = hall_gray(start_x:start_x+7,start_y:start_y+7);  % ѡȡ���ں������������
figure;
subplot(2,3,1); 
imshow(target,'InitialMagnification','fit');    % ��ʾԭʼͼ��
title('ԭʼͼ��');
% �任��
C = mydct2(double(target));  % ʹ���˿⺯��double��unit8תΪ���ڼ����double
% �Ҳ�4������
C_r = C;
C_r(:,5:8) = 0;
P_r = uint8(myidct2(C_r)); % ��ԭ������
subplot(2,3,2);
imshow(P_r,'InitialMagnification','fit');    % ��ʾ�Ҳ�4�������ͼ��
title('�任���Ҳ�4��Ϊ0ͼ��');
% ���4������
C_l = C;
C_l(:,1:4) = 0;
P_l = uint8(myidct2(C_l)); % ��ԭ������
subplot(2,3,3);
imshow(P_l,'InitialMagnification','fit');    % ��ʾ���4�������ͼ��
title('�任�����4��Ϊ0ͼ��');
% ת��
C_t = C';
P_t = uint8(myidct2(C_t)); % ��ԭ������
subplot(2,3,4);
imshow(P_t,'InitialMagnification','fit');    % ��ʾת�õ�ͼ��
title('�任��ת��ͼ��');
% ��ת90��
C_r90 = rot90(C);
P_r90 = uint8(myidct2(C_r90)); % ��ԭ������
subplot(2,3,5);
imshow(P_r90,'InitialMagnification','fit');    % ��ʾ��ת90�ȵ�ͼ��
title('�任����ת90��ͼ��');
% ��ת180��
C_r180 = rot90(C_r90);
P_r180 = uint8(myidct2(C_r180)); % ��ԭ������
subplot(2,3,6);
imshow(P_r180,'InitialMagnification','fit');    % ��ʾ��ת180�ȵ�ͼ��
title('�任����ת180��ͼ��');