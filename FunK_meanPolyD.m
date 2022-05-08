function [ res, record] = FunK_meanPolyD(data,k )
% 功能：
%     实现多维空间k-mean聚类算法
% 输入：
%     data是d*n规格的矩阵，其中d代表维度，n代表样本的数量
%     k 是分成的类别的数量
% 输出：
%     res 是行数为(d*k), 列数为record中最大元素值
%	  对于res的行数为d*k的解释： 
%		1:d 是对应着第一类别元素
%		d+1:2*d 是对应着第二类别元素 
%			··· 
%		d*(k-1)+1:d*k 是对应着第k类别元素
%
%     record规格为1*k,记录着每一类别的有效元素的个数

    j = 1;
    % 下面是预分配一些空间
    % seedX 和 seedY 中存放着所有种子
    [h w] = size(data);
    cnt = w; % 输入元素的数量
    cntOfDimension = h; % d 中存放着本次处理数据的维度
    %seed 中存放种子，每一行代表种子所在的一个维度，每一列是一个种子向量
    seed = zeros(cntOfDimension,k);
    oldSeed = zeros(cntOfDimension,k);
    % 结果矩阵res中，数据存放规则：
    %   以d行为一个单位，总共k个d行
    %   第一个d行数据存放着第一类元素集合,其他同理
    res = zeros(k*cntOfDimension,cnt); 
    % 用来记录resX中每一行有效元素的个数
    record = zeros(1,k); 
    r = 0;
    for i = 1:k % 产生k个随机种子, 注意： 随机种子是来自元素集合
        t = round(rand()*cnt);
        % 为保证种子不重叠
        if i > 1 && t == r
            i = i - 1;
            continue;
        end
        
        seed(:,i) = data(:,t);
        r = t;
    end
    ht_count=1;
    while 1
        record(:) = 0; % 重置为零
        res(:) = 0;
        for i = 1:cnt % 对所有元素遍历
            % 下面是判断本次元素应该归为哪一类，这里我们是根据欧几里得距离进行类别判定
            % k-mean算法认为元素应该归为距离最近的种子代表的类
            distanceMin = 1; % distanceMin 中存放着最短欧几里得距离的种子点的下标
            for j = 2:k
                % 计算高维度的欧几里得距离
                a = 0;
                b = 0;
                for row = 1:cntOfDimension
                    a = a + power(data(row,i)-seed(row,distanceMin),2);
                    b = b + power(data(row,i)-seed(row,j),2);
                end
                if a > b
                    distanceMin = j;
                end
            end
            % 将本次元素点进行类别归并
            row = (distanceMin-1)*cntOfDimension + 1;
            res(row:row+cntOfDimension-1,record(distanceMin)+1) = data(:,i);
            record(distanceMin) = record(distanceMin)+1;
        end
        %record
        oldSeed = seed;
        % 移动种子至其类中心
        for col = 1:k
            if record(col) == 0
                continue;
            end
            % 计算新的种子位置
            row = (col-1)*cntOfDimension + 1;
            seed(:,col) = sum(res(row:row+cntOfDimension-1,:),2)/record(col);
        end
        % 如果本次得到的种子和上次的种子一致，则认为分类完毕。
        if mean(seed == oldSeed) == 1
            break;
        end
        figure
        ht_color=['r*';'g*';'b*';'k*'];
        
        for i = 1:k
        plot3(res(i*3-2,1:record(i)),res(i*3-1,1:record(i)),res(i*3,1:record(i)),'*')
        plot3(mean(res(i*3-2,1:record(i)),2),mean(res(i*3-1,1:record(i)),2),mean(res(i*3,1:record(i)),2),'Marker','square','Color','k','MarkerFaceColor','k','LineStyle','none')
        title(['聚类',num2str(ht_count),'次之后的数据点'],'FontSize',15);
        hold on%注意：hold on 要写在plot3之后，这样三维图形才会正常绘制
        end
        ht_count=ht_count+1;
    end
    
    maxPos = max(record);
    res = res(:,1:maxPos);
end
