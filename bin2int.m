function d = bin2int(b)
% bin2int �������Ķ���������bתΪ����d
%  �����ת���Ķ����ƴ�b���������d
sign=1;     % ����
if b(1)==0  
    b=1-b;  % ȡ��
    sign=-1;
end
d=char(b+'0');  % ��Ϊbin2dec���õ��ַ���
d=bin2dec(d)*sign;  % תΪ����
end
