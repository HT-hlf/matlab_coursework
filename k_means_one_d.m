% 利用K-均值聚类的原理，实现对一组数据的分类。这里以一组一维的点为例。 14 个人 , 根据其年龄 , 将数据集分成 3 组 ;
clc;clear;
X=[1,3,5,8,9,11,12,13,37,43,45,49,51,65];
Y=ones(1,14);%为了便于表示一维数据聚类情况，将y坐标统一成1，便于在二维图上的理解
N = 14; % 点的个数
%% 画出原始数据点，即下面的5行代码。扩展：选中该5行代码，ctrl+t可去掉%，按ctrl+r可快速加入注释%
% % % figure(1)
% % % plot(X, Y, 'r*'); % 绘出原始的数据点
% % % xlabel('X');
% % % ylabel('Y');
% % % title('聚类之前的数据点');
%%
K = 3; %将所有的数据点分为3类，为了便于本文的理解与扩展，这里K下文没有用到，但是自己动手利用K将代码合并，从而适应其他分类情况。
n = 3; %将所有的数据点分为3类
m = 1; %迭代次数。由于将聚类中心的初始值作为1次迭代结果，所以m初始值为1，所以后面算迭代次数的时候需要减1。
eps = 1e-7; % 迭代结束的阈值
%% 这里和链接中的取值样本相同，也可以随机选取三个样本
u1 = [1,1]; %初始化第一个聚类中心
u2 = [20,1]; %初始化第二个聚类中心
u3 = [40,1]; %初始化第三个聚类中心
% % % %% 随机选取样本，下面4行代码为样本集中随机选取3个样本
% % % suiji=randperm(14,3);  %  p = randperm(n,k) 返回行向量，其中包含在 1 到 n 之间随机选择的 k 个唯一整数。
% % %                        %  扩展：p = randperm(n) 返回行向量，其中包含从 1 到 n 没有重复元素的整数随机排列。
% % % u1=[X(suiji(1)),Y(suiji(1))];%注意对于一维，Y表示在同一纵坐标的固定数值，Y的数值不变
% % % u2=[X(suiji(2)),Y(suiji(2))];
% % % u3=[X(suiji(3)),Y(suiji(3))];
%%
U1 = zeros(2,50);%U1,U2，U3用于存放各次迭代3个聚类中心的横纵坐标
U2 = zeros(2,50); 
U3 = zeros(2,50);
 
U1(:,2) = u1; %由于需要算两次迭代差值，所以U1从第二列开始赋值
U2(:,2) = u2;
U3(:,2) = u3;
D = zeros(n,N); %初始化数据点与聚类中心的距离
 
while(abs(U1(1,m) - U1(1,m+1)) > eps || abs(U2(1,m) - U2(1,m+1)) > eps ||  abs(U3(1,m) - U3(1,m+1)) > eps )%上一次迭代后的聚类中心值与本次迭代的差值。
   %上一行代码中， m=1时表示0与初始值的差值，U1(1,m+1)实际表示第m-1轮迭代后聚类中心数值结果
    m = m +1;
%% 计算所有点到3个聚类中心的距离
for i = 1 : N
    D(1,i) = abs(X(i) - U1(1,m));%各点到中心的距离,abs绝对值函数
end
for i = 1 : N
    D(2,i) = abs(X(i) - U2(1,m));
end
for i = 1 : N
    D(3,i) = abs(X(i) - U3(1,m));
end
%%
A = zeros(2,N); % A用于存放第一类的数据点
B = zeros(2,N); % B用于存放第二类的数据点
C = zeros(2,N); % C用于存放第三类的数据点
for k = 1: N
    [MIN,index] = min(D(:,k)); %MIN向量记录A的每列的最小值，index向量记录每列最小值的行号
    if index == 1             % 点属于第一个聚类中心
        A(1,k) = X(k);
        A(2,k) = Y(k);
    else
        if   index == 2       % 点属于第二个聚类中心
        B(1,k) = X(k);
        B(2,k) = Y(k);
        else                  % 点属于第三个聚类中心
        C(1,k) = X(k);
        C(2,k) = Y(k);
        end
    end
end
indexA = find(A(1,:) ~= 0); % 找出第一类中的点,~=表示不等于0
indexB = find(B(1,:) ~= 0); % 找出第二类中的点
indexC = find(C(1,:) ~= 0); % 找出第三类中的点
 
%% 下面这6行个是真正的聚类中心，再下面那6行是为了验证链接提供的推导过程
U1(1,m+1) = mean(A(1,indexA));% 更新三个聚类中心
U1(2,m+1) = mean(A(2,indexA));
U2(1,m+1) = mean(B(1,indexB));
U2(2,m+1) = mean(B(2,indexB));
U3(1,m+1) = mean(C(1,indexC));
U3(2,m+1) = mean(C(2,indexC));
 
%% 链接的博客中为了便于推导和理解，对于计算后的值，取整数部分作为新的聚类中心值。下面7行代码用了向零方向取整的数值作为聚类中心。
%更新三个聚类中心。其中mean表示求数组平均值的函数，fix表示向零方向取整。扩展：ceil向无穷大方向取整，round四舍五入取整。
% U1(1,m+1) =fix(mean(A(1,indexA)));
% U1(2,m+1) =fix(mean(A(2,indexA)));
% U2(1,m+1) =fix(mean(B(1,indexB)));
% U2(2,m+1) =fix(mean(B(2,indexB)));
% U3(1,m+1) =fix(mean(C(1,indexC)));
% U3(2,m+1) =fix(mean(C(2,indexC)));
%%
juleizhongxin=[U1(1,m+1),U2(1,m+1),U3(1,m+1)];%聚类后的中心
disp(['当前迭代的次数为:',num2str(m)-1]);
disp(['更新后的聚类中心是:',num2str(juleizhongxin)]);
%%
% % % figure(m-1);%每次迭代的结果绘图，若只最终迭代结果，则把这部分代码放到最后，figure(m)改成figure
% % % plot(A(1,indexA) , A(2,indexA), '*b'); % 作出第一类点的图形
% % % hold on
% % % plot(B(1,indexB) , B(2,indexB), 'or'); %作出第二类点的图形
% % % hold on
% % % plot(C(1,indexC) , C(2,indexC), 'dk'); %作出第三类点的图形
% % % hold on
% % % 
% % % centerx = [U1(1,m+1) U2(1,m+1)  U3(1,m+1)];%聚类中心
% % % centery = [U1(2,m+1) U2(2,m+1)  U3(2,m+1)];
% % % 
% % % plot(centerx , centery, '+g'); % 画出每次迭代的聚类中心点
% % % xlabel('X');
% % % ylabel('Y');
% % % title('聚类之后的数据点');
 
end
%% 绘图 用不同颜色表示各类的点
figure(8);
plot(A(1,indexA) , A(2,indexA), '*b'); % 作出属于第一类点的图形
hold on
plot(B(1,indexB) , B(2,indexB), 'or'); %作出属于第二类点的图形
hold on
plot(C(1,indexC) , C(2,indexC), 'dk'); %作出属于第三类点的图形
hold on
 
centerx = [U1(1,m) U2(1,m)  U3(1,m)];
centery = [U1(2,m) U2(2,m)  U3(2,m)];
 
plot(centerx , centery, '+g'); % 画出最终的聚类中心点
xlabel('年龄/岁');
ylabel('Y');
title('聚类之后的数据点');
% % disp(['满足条件，终止迭代的次数为:',num2str(m)-1]);
%% 设置显示方式
nameqianzhui='满足最小阈值，在第';
diedai=m-1;
% % disp(sprintf('%s %d 次迭代后终止',nameqianzhui,diedai));
fprintf('%s %d 次迭代后终止\n',nameqianzhui,diedai);
 