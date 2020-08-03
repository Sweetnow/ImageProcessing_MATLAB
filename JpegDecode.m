clear; close all; clc;
% ���ر��������������
load jpegcodes.mat;  % ͼ�������
load JpegCoeff.mat   % ���
load hall.mat        % ԭͼ
load snow.mat        % ѩ��ͼ
% ����
raw_h = h;  % ԭʼͼ�񳤿�
raw_w = w;
Q = 1;      % ������������ϵ��
N = 8;      % �ֿ�߳�
preprocess_dec = 128;   % Ԥ����ʱ��ȥ��ֵ
zigzag_indice = zigzag(N,N);    % zigzag����
zigzag_indice = sub2ind([N,N],zigzag_indice(:,1),zigzag_indice(:,2));   % ������������Ϊ˳������
raw_pic = hall_gray;    % ԭͼ
use_spatial_hide = 0;   % ����/�رտ�����Ϣ����
use_dct_hide = 3;       % 0-�ر�DCT����Ϣ���� 1-DCT����1 2-DCT����2 3-DCT����3

% DC����
DC_hat = DCdecode(DC_code,DCTAB);
DC = zeros(size(DC_hat));   % ��ֽ����ԭ��ԭʼ���
DC(1)=DC_hat(1);
for n=2:length(DC)
    DC(n) = DC(n-1)-DC_hat(n);  % ���ݹ�ʽ��ԭ
end
% AC����
AC = ACdecode(AC_code,ACTAB,N);
% �ؽ�DCT�任���
C = [DC;AC];

switch use_dct_hide
    case 1 % DCT����Ϣ���ؼ�������1
        msg_bit = bitget(C,1,'int64');   % ��ȡ���1bit
        msg = bin2str(msg_bit(:));      % תΪ�ַ���
        disp(['DCT�����ط���1��ϢΪ',msg]);
    case 2 % DCT����Ϣ���ؼ�������2
        target_max = 15;    % ��������ݵ�DCTϵ����Ӧ���������ϵ��
        QTAB_zigzag = QTAB(zigzag_indice); % ��������Ҳ����zigzagʹ֮��C��ÿ��ƥ��
        target_indice = find(QTAB_zigzag<=target_max);   % ��������ݵ�λ��
        target_C = C(target_indice,:);     % ȡ����������ݵĲ���
        msg_bit = bitget(target_C,1,'int64');   % ��ȡ���1bit
        msg = bin2str(msg_bit(:));      % תΪ�ַ���
        disp(['DCT�����ط���2��ϢΪ',msg]);
    case 3
        block_cnt = size(C,2);      % ���õĿ�����
        msg_bit = zeros(block_cnt,1);
        for n=1:block_cnt
           nonzero_indice = find(C(:,n));       % �ҳ����з����������
           msg_bit(n)=C(nonzero_indice(end),n);     % �����һ���������ȡ����
        end
        msg_bit = (msg_bit+1)/2;        % ��ԭ��0/1��
        msg = bin2str(msg_bit(:));      % תΪ�ַ���
        disp(['DCT�����ط���3��ϢΪ',msg]);
end

% �ֿ��������
block_size = ceil([raw_h,raw_w]/N);    % �������ά���Ͽ������
extended_pic = zeros(N*block_size);     % ��չ���ͼ��
[extended_h,extended_w] = size(extended_pic); % ��չ��ͼ���С
% ����������ԭÿһ����
for m=1:block_size(1)   
    for n=1:block_size(2)
        column = (m-1)*block_size(2)+n;     % ѡ����Ӧ��DCT�任���
        c = zeros(N,N);
        c(zigzag_indice) = C(:,column);     % ��ԭzigzag���
        c = c.*QTAB*Q;            % ��ÿ������з�����
        extended_pic((m-1)*N+1:m*N,(n-1)*N+1:n*N) = myidct2(c); % DCT���任���������ص�
    end
end
% ȥ����չ�Ĳ���
pic = extended_pic(1:raw_h,1:raw_w);
% ��ԭԤ�������
pic = pic+preprocess_dec;
% �����������
pic(pic<0) = 0;
pic(pic>255)=255;

% ������Ϣ���ؼ���
if use_spatial_hide
    msg_bit = bitget(uint8(pic),1); % ��ȡ���1bit
    msg = bin2str(msg_bit(:));      % תΪ�ַ���
    disp(['����������ϢΪ',msg]);
end

% ����ͼ��
figure;
subplot(1,2,1);
imshow(raw_pic);
title('ԭͼ');
subplot(1,2,2);
imshow(uint8(pic));
if use_spatial_hide
    title('JPEG-������Ϣ���ط���3');
elseif use_dct_hide==1
    title('JPEG-DCT����Ϣ���ط���1');
elseif use_dct_hide==2
    title('JPEG-DCT����Ϣ���ط���2');
elseif use_dct_hide==3
    title('JPEG-DCT����Ϣ���ط���3');
else
    title('JPEG');
end
% ���۽�����
MSE = mean((double(raw_pic)-pic).^2,'all');
PSNR = 10*log10(255*255/MSE);
disp(['��������PSNRΪ',num2str(PSNR)]);

function DC = DCdecode(code,DCTAB)
% DC�ؽ��뺯��
% ���������code�����DCTAB
% �����ֺ��DCֵ
first=1;    % ��ʼ��
last=1;
DC = [];
while last<=length(code)    % ɨ�赽��β����
    len = last-first+1;     % ��ǰ���볤��
    target = zeros(1,size(DCTAB,2)-1);
    target(1:len)=code(first:last);    % ��ǰ���ı�������
    target_row_index = find(all(DCTAB(:,2:end)==target,2)); % ��������ҵ���Ӧ����
    if ~isempty(target_row_index) && DCTAB(target_row_index,1)==len    % ���ڶ�Ӧ�����ҳ���һ�£��ж�Ϊ����ɹ�
        category = target_row_index(1)-1;   % �������ֳ���
        if category>0
            val = bin2int(code(last+1:last+category));  % ��0ֵ����
            DC = [DC,val];
        else
            DC = [DC,0];    % 0ֱ�Ӵ���
        end
        first = last+category+1;    % �Ӻ�����������
        last = first;
    else
        last=last+1;                % ���벻�ɹ���last������������
    end
end
end

function AC = ACdecode(code,ACTAB,N)
% AC�ؽ��뺯��
% ���������code�����ACTAB��block�߳�N
% ���ACֵ����ÿ��Ϊһ��block
first=1;    % ��ʼ��
last=1;
AC=[];      % ACֵ����
AC_now=zeros(1,N*N-1);  % ��ǰblock�Ľ��
AC_next=1;  % ��ǰblock�������дλ������
while last<=length(code)    % ɨ�赽��β����
    len = last-first+1;     % ��ǰ���볤��
    target = zeros(1,size(ACTAB,2)-3);
    target(1:len)=code(first:last);    % ��ǰ���ı�������
    target_row_index = find(all(ACTAB(:,4:end)==target,2)); % ��������ҵ���Ӧ����
    if all(target(1:4)==[1,0,1,0],'all') && len == 4        % EOB
        AC = [AC;AC_now];   % �������飬�����������������
        AC_now=zeros(1,N*N-1);  % ���³�ʼ����ǰ��
        AC_next=1;
        last = last+1;     % �Ӻ�����������
        first = last;
    elseif all(target(1:11)==[1,1,1,1,1,1,1,1,0,0,1],'all') && len == 11        % ZRL
        AC_next=AC_next+16;     % ֱ������16��������ʼ��ʱ��0��
        last = last+1;     % �Ӻ�����������
        first = last;
    elseif ~isempty(target_row_index) && ACTAB(target_row_index,3)==len    % ���ڶ�Ӧ�����ҳ���һ�£��ж�Ϊ����ɹ�
        row = target_row_index(1);
        run = ACTAB(row,1);         % ȡ���γ���
        category = ACTAB(row,2);    % �������ֳ���
        AC_next = AC_next+run;      % ֱ������һ��������������ʼ��ʱ��0��
        val = bin2int(code(last+1:last+category));  % ��0ֵ����
        AC_now(AC_next) = val;
        AC_next = AC_next+1;        
        last = last+category+1;     % �Ӻ�����������
        first = last;
    else
        last=last+1;                % ���벻�ɹ���last������������
    end
end
AC=AC';
end