clear; close all; clc;
% ����
image_cnt = 33; % ѵ��ʹ�õ�ͼ����
N = 8;  % ���ɫλ��
L = 5;  % ��ɫλ��
v = zeros(2^(3*L),1); % ��������

for n=1:image_cnt  % ��������ͼ��
    pic=imread(['Faces/',num2str(n),'.bmp']);   % ��ȡͼƬ
    v = v+pic2vec(pic,L);   % ͼ��תΪ��������
end
v = v/image_cnt;    % �����ֵ

% ��������㷨
% ����
image_path = 'test.jpg';    % �����ļ�
windows = [20,40,60]';    % ɨ�贰��С
steps = [5,10,15]';       % ÿ��ɨ�贰�ƶ�����
ratio = 0.5;                % �ϲ��жϱ�׼
switch L    % ��ͬ��L��Ӧ��ͬ��ֵ
    case 3
        epison = 0.20;
    case 4
        epison = 0.40;
    case 5
        epison = 0.55;
end
               
% ��ȡͼ��
pic = imread(image_path);
[h,w,~]=size(pic);          % ��ȡͼ���С
% pic = imresize(pic,[h,2*w]); % ����
pic = imrotate(pic,-90);   % ��ת
% pic = imadjust(pic,[0.2,0.8]); % �ı���ɫ
[h,w,~]=size(pic);          % ��ȡͼ���С
targets = [];               % ÿ�д���һ��Ŀ���x,y,w,h����ʽ����ѡ��
for n = 1:length(windows)   % ��������ɨ�贰��С
    win = windows(n);
    step = steps(n);
    for row=1:step:h-win+1  % ����ͼ��
        for col=1:step:w-win+1
            this_v = pic2vec(pic(row:row+win-1,col:col+win-1,:),L); % ���㴰�ڵ���������
            dist = face_distance(this_v,v);
            if dist < epison  % �ӽ���������������
                y = row;              % ����Ŀ��������
                x = col;
                targets = [targets;[x,y,win,win]];  % �����ѡ��
            end
        end
    end
end
% ��ⴰ�ϲ�
while 1 % �ظ��ϲ�ֱ��û����Ҫ�ϲ��ļ�ⴰ
    merged_targets = []; % �ϲ����
    for n=1:size(targets,1) % ������ǰ��ⴰ
        target = targets(n,:);
        if isempty(merged_targets) % ����ϲ����Ϊ�գ������
            merged_targets=[merged_targets;target];
        else
            num = size(merged_targets,1); % ��Ϊ������һ�Աȵ�ǰ�����Ѿ�������Ĵ�
            flag=1; % flagΪ1��ʾ��ǰ������֮ǰ�κ�һ��ƥ�䣬��Ҫֱ����Ϊһ�������Ľ��
            for m=1:num
                compared_target=merged_targets(m,:); % ���ȽϵĴ�
                if check_merge(compared_target,target,ratio) % �ж��Ƿ���Ժϲ�
                    merged_targets(m,:)=merge_recs([compared_target;target]); % �ϲ���
                    flag=0; % ��ʾ�Ѻϲ���
                    break;  % ����һ�κϲ�����ǰ��������
                end
            end
            if flag
                merged_targets=[merged_targets;target]; % ��δ�������ϲ��ģ���Ҫ��Ϊһ�������Ľ��
            end
        end
    end
    if all(size(merged_targets)==size(targets)) % ���һ��ѭ����û���κκϲ���������Ϊ�Ѿ������ڿɺϲ��Ĵ����˳��ϲ�����
        break;
    end
    targets = merged_targets; % �������ںϲ��Ĵ�
end
imshow(pic); % ��ʾͼ��
for n=1:size(targets,1)
    rectangle('Position',targets(n,:),'EdgeColor','r'); %��ʾ��
end
% title(['L=',num2str(L)]);
title('��ת�Ƕ�');

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

function d = face_distance(v1,v2)
% distance ��������v1��v2�ľ��루����ʽ4.13��
d=1-sum(sqrt(v1.*v2),'all');
end

function bool = check_merge(rec1,rec2,ratio)
% ���������ѡ���Ƿ���Ժϲ����жϵ������ǽ���ռ��С��ı����Ƿ���ڱ���ratio
% �����������ο�rec1 rec2 [x,y,w,h]��ʽ,ratioΪռ�ȵ���ֵ
% ����Ƿ�ϲ�bool
s1 = rec1(:,3).*rec1(:,4);  % �����ѡ�����
s2 = rec2(:,3).*rec2(:,4);
min_s = min(s1,s2);         % �����С������
% ���㽻��
left = max(rec1(:,1),rec2(:,1));                        % ��߿�����ֵ
right = min(rec1(:,1)+rec1(:,3),rec2(:,1)+rec2(:,3));   % �ұ߿����Сֵ
up = max(rec1(:,2),rec2(:,2));                          % �ϱ߿�����ֵ
down = min(rec1(:,2)+rec1(:,4),rec2(:,2)+rec2(:,4));    % �±߿����Сֵ
mask = (right>left) & (down>up);                        % ��������
inter_s = (down-up).*(right-left);                      % �������
inter_s(~mask)=0;                                       % �޽���������
bool = (inter_s>=(ratio*min_s));                        % �ж��Ƿ���Ժϲ�
end

function rec = merge_recs(recs)
% �ϲ�������ο򣬷��غϲ����
% ������ο�������ÿһ�д���һ�����ο�����ϲ����
rec_left = min(recs(:,1));                        % ��߿����Сֵ
rec_right = max(recs(:,1)+recs(:,3));             % �ұ߿�����ֵ
rec_up = min(recs(:,2));                          % �ϱ߿����Сֵ
rec_down = max(recs(:,2)+recs(:,4));    % �±߿�����ֵ
rec=[rec_left,rec_up,rec_right-rec_left,rec_down-rec_up];
end