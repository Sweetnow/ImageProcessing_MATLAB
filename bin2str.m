function s = bin2str(b)
%   bin2str �������ƴ�תΪ�ַ���
%   ���������������ƴ������ض�Ӧ���ַ���
t = char(b+'0');        % �任���ַ�0/1��
len = floor(length(t)/8);
t = t(1:len*8);
t = reshape(t,8,length(t)/8);   % ÿ8��һ�У���ԭ��״
s = char(bin2dec(t'))';          % bin2dec��ԭ
end

