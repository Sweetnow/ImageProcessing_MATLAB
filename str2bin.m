function b = str2bin(s)
%   str2bin ���ַ���תΪ�����ƴ�
%   ����char[]���ַ��������ض�Ӧ�Ķ����ƴ�������
t=dec2bin(uint8(s),8)';  % �任Ϊ�ַ�����ʾ�Ķ���������
t=t(:);                 % չƽ
b=(double(t)-'0');     % �任Ϊdouble���͵�0/1������
end

