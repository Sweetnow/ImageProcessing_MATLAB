clear; close all; clc;
% ��������
b=[-1,1];
a=1;
% ����Ƶ����Ӧ
figure;
n = 2001;       % Ƶ����Ӧ����
[h,w] = freqz(b,a,'whole',n);   % ��ȡƵ����Ӧ
subplot(1,2,1);
plot(w/pi,abs(h));  % ��ͼ����
xlabel("freq/pi");
ylabel("����");
title("Ƶ����Ӧ�����ȣ�");
subplot(1,2,2);
plot(w/pi,angle(h)*180/pi); % ��ͼ��λ
xlabel("freq/pi");
ylabel("���/��");
title("Ƶ����Ӧ����λ��");
