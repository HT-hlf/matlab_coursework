% k-mean�㷨��˼���ϻ��Ǵ��ڱ׶˵�
% k-mean�㷨�ǻ���ŷ����ÿռ������л����ж��ģ���ʵ��״���в�һ������Ҫ��ŷ����ÿռ������Ϊ�жϻ�����

% �����Ƕ�άk-mean
% clear all
% close all
% t = 1000;%ָ������Ԫ�ظ���
% x = rand(1,t);% ������������
% y = rand(1,t);
% k = 7;% ָ���������
% % 
% [resX,resY,record] = FunK_mean(x,y,k);% record �д����ÿһ�������ĳ�Ա���� 
% % ע��Ϊ�˱�д���㣬resX,resY ���Զ�ά�������ʽ����
% % resX(i,:) ��resY(i,:) ��ʾ��i�����������г�Ա��
% % ����Ч��Ա����Ŀ��һ������length(resX(i,:)),���ǵ���record(i)
% % ����Ŀ�λ������������
% hold on
% for i = 1:length(record)
%     plot(resX(i,1:record(i)),resY(i,1:record(i)),'*')
% end
% % �����Ǳ�ǳ�ÿһ�������������
% for i = 1:length(record)
%     plot(mean(resX(i,1:record(i)),2)',mean(resY(i,1:record(i)),2)','Marker','square','Color','k','MarkerFaceColor','k','LineStyle','none')
% end
% hold off



% % ��ά��k-mean
% 
% clear all
% close all
% t = 1000;
% x = rand(1,t);
% y = rand(1,t);
% z = rand(1,t);
% k = 5;
% 
% [resX resY resZ record] = FunK_mean3D(x,y,z,k);
% 
% for i = 1:length(record)
%     plot3(resX(i,1:record(i)),resY(i,1:record(i)),resZ(i,1:record(i)),'*')
%     hold on
% end
% % �����Ǳ�ǳ�ÿһ�������������
% for i = 1:length(record)
%     plot3(mean(resX(i,1:record(i)),2)',mean(resY(i,1:record(i)),2)',mean(resZ(i,1:record(i)),2)','Marker','square','Color','k','MarkerFaceColor','k','LineStyle','none')
% end

%�����Ƕ�ά k-mean��ʾ����,����2ά��3ά�ȣ���ά��
clear all
close all
t = 2000;
d = 3;
data = rand(d,t);
k = 5;
[res, record] = FunK_meanPolyD(data,k);

[h, w] = size(res);
if h/k == 2
    hold on
    for i = 1:k
        plot(res(i*2-1,1:record(i)),res(i*2,1:record(i)),'*')
        plot(mean(res(i*2-1,1:record(i)),2),mean(res(i*2,1:record(i)),2),'Marker','square','Color','k','MarkerFaceColor','k','LineStyle','none')
    end
    hold off
elseif h/k == 3
    for i = 1:k
        plot3(res(i*3-2,1:record(i)),res(i*3-1,1:record(i)),res(i*3,1:record(i)),'*')
        plot3(mean(res(i*3-2,1:record(i)),2),mean(res(i*3-1,1:record(i)),2),mean(res(i*3,1:record(i)),2),'Marker','square','Color','k','MarkerFaceColor','k','LineStyle','none')
        hold on%ע�⣺hold on Ҫд��plot3֮��������άͼ�βŻ���������
    end
    hold off
else
    disp(['���ά�ȴ���3ά�����ܽ��л���'])
end

