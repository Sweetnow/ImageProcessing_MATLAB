clear; close all; clc;
% �������ݲ����㳤��
load('hall.mat');
[v,h,~]=size(hall_color);
x = 1:h;
y = 1:v;
[xx,yy]=meshgrid(x,y); % ���ɾ�������
R = hall_color(:,:,1); % ��ȡ��ɫ����
G = hall_color(:,:,2); % ��ȡ��ɫ����
B = hall_color(:,:,3); % ��ȡ��ɫ����
% ����Բ
r = min(h,v)/2;        % ����뾶
distance = ((xx-h/2).^2+(yy-v/2).^2).^0.5; % ��������㵽���ĵľ���
is_red = distance<r;    % ȷ����Բ��Χ
red_R = R;red_B = B;red_G = G;
red_R(is_red) = 255;        % ��Բ
red_B(is_red) = 0;
red_G(is_red) = 0;
red_circle = cat(3,red_R,red_G,red_B);  % �ؽ�ͼ��
figure;
imshow(red_circle);         % ��ʾͼ��
imwrite(red_circle,'red_circle.jpg');   % ����ͼ��

% ���ڰ׸�
square_a = 10;  % ���񳤶�
square_xx = floor(xx/square_a);     % ȷ������ķ�������
square_yy = floor(yy/square_a);     % ȷ������ķ�������
is_black = uint8(mod(square_xx + square_yy,2)); % ȷ��Ϳ������
square_R = R.*is_black;     % Ϳ��
square_G = G.*is_black;
square_B = B.*is_black;
square = cat(3,square_R,square_G,square_B); % �ؽ�ͼ��
figure;
imshow(square); % ��ʾͼ��
imwrite(square, 'square.jpg');   % ����ͼ��



