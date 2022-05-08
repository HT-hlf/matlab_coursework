% k-mean算法在思想上还是存在弊端的
% k-mean算法是基于欧几里得空间距离进行基本判定的，而实际状况中不一定就是要以欧几里得空间距离作为判断基础的

% 下面是二维k-mean
% clear all
% close all
% t = 1000;%指定样本元素个数
% x = rand(1,t);% 产生样本数据
% y = rand(1,t);
% k = 7;% 指定类别数量
% % 
% [resX,resY,record] = FunK_mean(x,y,k);% record 中存放着每一个类别组的成员数量 
% % 注意为了编写方便，resX,resY 是以二维矩阵的形式呈现
% % resX(i,:) 和resY(i,:) 表示第i个类别组的所有成员，
% % 但有效成员的数目不一定等于length(resX(i,:)),而是等于record(i)
% % 多余的空位是用零来填充的
% hold on
% for i = 1:length(record)
%     plot(resX(i,1:record(i)),resY(i,1:record(i)),'*')
% end
% % 下面是标记出每一个类别的类别代表点
% for i = 1:length(record)
%     plot(mean(resX(i,1:record(i)),2)',mean(resY(i,1:record(i)),2)','Marker','square','Color','k','MarkerFaceColor','k','LineStyle','none')
% end
% hold off



% % 三维度k-mean
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
% % 下面是标记出每一个类别的类别代表点
% for i = 1:length(record)
%     plot3(mean(resX(i,1:record(i)),2)',mean(resY(i,1:record(i)),2)',mean(resZ(i,1:record(i)),2)','Marker','square','Color','k','MarkerFaceColor','k','LineStyle','none')
% end

%下面是多维 k-mean演示部分,包括2维，3维度，高维度
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
        hold on%注意：hold on 要写在plot3之后，这样三维图形才会正常绘制
    end
    hold off
else
    disp(['结果维度大于3维，不能进行绘制'])
end

