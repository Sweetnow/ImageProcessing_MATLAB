clear; close all; clc;
% ����ͼ�����������
load hall.mat;  % ͼ��
load snow.mat   % ѩ��ͼ
load JpegCoeff.mat % ���
pic = hall_gray;
% �趨����
Q = 1;                  % ������������ϵ��
N = 8;                  % �ֿ�߳�
preprocess_dec = 128;   % Ԥ����ʱ��ȥ��ֵ
[raw_h,raw_w] = size(pic);         % ԭʼͼ���С
zigzag_indice = zigzag(N,N);    % zigzag����
zigzag_indice = sub2ind([N,N],zigzag_indice(:,1),zigzag_indice(:,2));   % ������������Ϊ˳������
use_spatial_hide = 0;   % ����/�رտ�����Ϣ����
use_dct_hide = 3;       % 0-�ر�DCT����Ϣ���� 1-DCT����1 2-DCT����2 3-DCT����3
msg = 'Copyright@zhangjun';    % ��Ϣ
msg_bit_cnt = length(msg)*8;   % ��ϢתΪ�����ƺ�ĳ���

% ������Ϣ
if use_spatial_hide || use_dct_hide
    msg_bit = str2bin(msg);
end
% ������Ϣ���ؼ���
if use_spatial_hide
    % �ظ���Ϣ���������ͼƬ
    pixel = raw_h*raw_w;    % ���������ص���
    repeat_cnt = ceil(pixel/msg_bit_cnt);   % �����ظ�����
    spatial_msg_bit = repmat(msg_bit,repeat_cnt,1); % �����ظ���������
    spatial_msg_bit = spatial_msg_bit(1:pixel);     % ɾȥ�����Ĳ���
    pic = bitset(pic,1,reshape(spatial_msg_bit,size(pic))); % �޸����һ��bit
end

% ͼ��Ԥ����
pic = double(pic)-preprocess_dec;
% �ֿ��벹ȫ
block_size = ceil(size(pic)/N);    % �������ά���Ͽ������
extended_pic = zeros(N*block_size);     % ��չ���ͼ��
[extended_h,extended_w] = size(extended_pic); % ��չ��ͼ���С
extended_pic(1:raw_h,1:raw_w) = pic;
if raw_h<extended_h
    extended_pic(raw_h+1:end,:) = repmat(extended_pic(raw_h,:),extended_h-raw_h,1);    % �в�ȫ
end
if raw_w<extended_w
    extended_pic(:,raw_w+1:end) = repmat(extended_pic(:,raw_w),1,extended_w-raw_w);    % �в�ȫ
end
% ����ÿ���飨DCT ������
C = zeros(N*N,block_size(1)*block_size(2));
for m=1:block_size(1)   
    for n=1:block_size(2)
        block = extended_pic((m-1)*N+1:m*N,(n-1)*N+1:n*N);  % ѡ���
        c = round(mydct2(block)./(QTAB*Q));     % ��ÿ�������DCT�任������
        c = c(zigzag_indice);               % zigzag����
        column = (m-1)*block_size(2)+n;
        C(:,column) = c;                    % ����C
    end
end % ����ʵ����8Ҫ��

switch use_dct_hide
    case 1  % DCT����Ϣ���ؼ�������1
        % �ظ���Ϣ����������任��
        [C_h,C_w] = size(C);
        C_cnt = C_h*C_w;    % ����C�����С
        repeat_cnt = ceil(C_cnt/msg_bit_cnt);       % �����ظ�����    
        dct1_msg_bit = repmat(msg_bit,repeat_cnt,1);% �����ظ���������
        dct1_msg_bit = dct1_msg_bit(1:C_cnt);       % ɾȥ�����Ĳ���
        C = bitset(C,1,reshape(dct1_msg_bit,size(C)),'int64'); % �޸����һ��bit
    case 2  % DCT����Ϣ���ؼ�������2
        target_max = 15;    % ��������ݵ�DCTϵ����Ӧ���������ϵ��
        QTAB_zigzag = QTAB(zigzag_indice); % ��������Ҳ����zigzagʹ֮��C��ÿ��ƥ��
        target_indice = find(QTAB_zigzag<=target_max);   % ��������ݵ�λ��
        target_C = C(target_indice,:);     % ȡ����������ݵĲ���
        [C_h,C_w] = size(target_C);
        C_cnt = C_h*C_w;    % ����C�����С
        repeat_cnt = ceil(C_cnt/msg_bit_cnt);       % �����ظ�����    
        dct2_msg_bit = repmat(msg_bit,repeat_cnt,1);% �����ظ���������
        dct2_msg_bit = dct2_msg_bit(1:C_cnt);       % ɾȥ�����Ĳ���
        target_C = bitset(target_C,1,reshape(dct2_msg_bit,size(target_C)),'int64'); % �޸����һ��bit
        C(target_indice,:) = target_C;              % ��������
    case 3  % DCT����Ϣ���ؼ�������3
        block_cnt = size(C,2);      % ���õĿ�����
        dct3_msg_bit=2*msg_bit-1;   % תΪ1 -1��ʾ
        repeat_cnt = ceil(block_cnt/msg_bit_cnt);       % �����ظ�����   
        dct3_msg_bit = repmat(dct3_msg_bit,repeat_cnt,1);% �����ظ���������
        dct3_msg_bit = dct3_msg_bit(1:block_cnt);       % ɾȥ�����Ĳ���
        for n=1:block_cnt
           nonzero_indice = find(C(:,n));       % �ҳ����з����������
           if nonzero_indice(end) == size(C,1)  % ���һ��������Ϊ���������һ��
               target = nonzero_indice(end);    % �޸����һ��ϵ��
           else
               target = nonzero_indice(end)+1;  % �޸����һ������ϵ���ĺ�һ��
           end
           C(target,n)=dct3_msg_bit(n);     % �޸�����
        end
end



% DC�ر���
DC = C(1,:);                        % ��ȡֱ������
DC_hat = [2*DC(1),DC(1:end-1)]-DC;  % �������
DC_code = DCencode(DC_hat,DCTAB);   % ����DC����

% AC�ر���
AC_code = [];
for block=1:size(C,2)
    AC = C(2:end,block)';
    AC_code = [AC_code,ACencode(AC,ACTAB)];
end

% ������
h=raw_h;
w=raw_w;
save('jpegcodes.mat','h','w','DC_code','AC_code');
% ����ѹ����
input_byte = raw_h*raw_w;   % ����ͼ����������Ϊuint8��ÿһ��ռ1B
output_byte = (length(DC_code)+length(AC_code))/8;  % �������Ϊ����������ÿ8��ռ1B
ratio = output_byte/input_byte;
disp(['ѹ����Ϊ',num2str(ratio),':1']);


function code = DCencode(DC,DCTAB)
% DC���뺯��
% ����������DC�����DCTAB
% ��������Ľ��������code
code = [];                       % DC����
DC_cat = floor(log2(abs(DC)))+1;% ת��ΪCategory
DC_cat(DC==0) = 0;              % �޸�Category 0
for n =1:length(DC)             % ������������
    category = DC_cat(n);       % ��ȡcategory
    len = DCTAB(category+1,1);  % ��ȡ����
    code = [code, DCTAB(category+1,2:1+len),int2bin(DC(n),category)];   % ��code�󸽼��µı�����
end
end

function code = ACencode(AC,ACTAB)
% AC���뺯��
% ����������AC�����DCTAB
% ��������Ľ��������code
zero_cnt=0;     % ����֮ǰ���ֹ���0�ĸ���
code=[];        % ����
for n=1:length(AC)  % ��ÿ��ֵѭ��
    now_num = AC(n);    % ��ǰֵ
    if now_num==0       % ��ǰֵΪ0�����
        zero_cnt = zero_cnt+1;
    else                % ��Ϊ0
        while zero_cnt >= 16     % ����ZRL�����
            code=[code,[1,1,1,1,1,1,1,1,0,0,1]];
            zero_cnt = zero_cnt - 16;
        end
        category = floor(log2(abs(now_num)))+1;  % ����size
        runsize_row_index = all(ACTAB(:,1:2)==[zero_cnt,category],2);   % ��ȡ(run/size)��Ӧ�������
        runsize_row = ACTAB(repmat(runsize_row_index,1,size(ACTAB,2)))';
        len = runsize_row(3);   % ��ȡ���볤��
        code=[code,runsize_row(4:3+len),int2bin(now_num,category)]; % �����µı�����
        zero_cnt=0;
    end
end
code = [code,[1,0,1,0]];    % ������
end