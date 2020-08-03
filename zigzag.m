function indice = zigzag(h,w)
%ZIGZAG ����h*w�Ķ�ά�������zigzag������·��
%   ���������״h,w  ����±�����
indice = [1,1]; % ����������ʼ״̬
now = [1,1];    % ��ʼ��
direction_loop={'edge','southwest','edge','northeast'}; % �ƶ������ѭ��˳��
i=1;    % ѭ�����southwest
while any(now ~= [h,w]) % �ﵽ���½��˳�
    direction = direction_loop{i};  % ѡ����
    next = zigzag_next(h,w,now,direction);  % �����յ�
    if ~strcmp(direction,'edge')
        if next(1)>now(1)   % ��������/���ٵ�ά�ȵ����������ɷ�ʽ
            nexts = [now(1):1:next(1);now(2):-1:next(2)]';  % ��㵽�յ�������仯����
        else
            nexts = [now(1):-1:next(1);now(2):1:next(2)]';  % ��㵽�յ�������仯����
        end
        nexts = nexts(2:end,:); % �ų���ǰ��
    else
        nexts = next;   % ��Եֻ�ƶ�һ����λ���ȣ�����Ҫ���⴦��
    end
    indice = [indice;nexts];    % ƴ������
    now = next;                 % ���µ�ǰ��
    i = mod(i,4)+1; % ѡ����һ����
end
end

function next_pos = zigzag_next(h,w,now_pos,direction)
% ����������zigzag����һ��ָ�������ƶ��������յ�
% direction: 'southwest', 'northeast', 'edge' ����ƶ�����ǰ����Ϊб����еģ����Ϊ�ر�Եǰ��һ��
% h,wΪ���󳤿�
% now_pos Ϊ��ǰλ��

% ��������1����ʼ���겻�ڷ�Χ��
if now_pos(1) > h || now_pos(1) < 1 || now_pos(2) > w || now_pos(2) < 1
    ME = MException('zigzag:wronginput', 'now_pos should be in [1:h]*[1:w]');
    throw(ME);
end
% ��������2����ʼ�����ѵ���zigzag�յ�
if now_pos(1) == h && now_pos(2) == w
    ME = MException('zigzag:wronginput', 'now_pos is at the end');
    throw(ME);
end
switch direction
    % �����ǰ���ڱ�Ե����ˮƽ/��ֱ�ƶ�һ����λ���Ⱦ���
    case 'edge'
        if (now_pos(1)==1 || now_pos(1)==h) && now_pos(2) ~= w % ��ǰ������/�±߽磨�ų����Ͻǣ�ʱ��ˮƽ����һ����λ����
            next_pos = now_pos + [0,1];
        elseif now_pos(2)==1 || now_pos(2)==w % ��ǰ�������ұ߽磨���ų����ϡ����¡����½ǣ�ʱ����ֱ����һ����λ����
            next_pos = now_pos + [1,0];
        else
            ME = MException('zigzag:wronginput', 'now_pos is not at the edge'); % ��������3����ǰ�㲻�ڱ�Ե
            throw(ME);    
        end
    % �����·��ƶ�
    case 'southwest'
        sum_pos = sum(now_pos);     % �������к�
        x = min(sum_pos-1, h);      % ��������ʱֻ�������һ��
        next_pos = [x, sum_pos-x];  % ���к�һ��һ��
    % �����Ϸ��ƶ�
    case 'northeast'
        sum_pos = sum(now_pos);     % �������к�
        y = min(sum_pos-1, w);      % ��������ʱֻ�������һ��
        next_pos = [sum_pos-y, y];  % ���к�һ��һ��
    % ��������4�� ������ָ��ѡ����
    otherwise
        ME = MException('zigzag:wronginput', 'direction should be `southwest`, `northeast` or `edge`');
        throw(ME);
end
end
