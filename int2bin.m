function b = int2bin(d,n)
%INT2BIN ������������dתΪnλ���������У������Է����ʾ
%  �����ת��������d��λ��n ��������ƴ�b
if d>=0
    b=dec2bin(d,n); % ����ֱ��ת��
else
    b=['0',dec2bin(2^n+d-1,n-1)];   % ������תΪ�����Ӧ��������ת��
end
b=double(b)-'0';    % charתΪdouble
end

