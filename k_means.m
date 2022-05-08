clear all;
close all;
clc;
%第一类数据
a=[0 0 ];  
S1=[.1 0 ;0 .1];  
data1=mvnrnd(a,S1,100);   %产生高斯分布数据
%第二类数据
b=[1.2 1.2 ];
S2=[.1 0 ;0 .1];
data2=mvnrnd(b,S2,100);
% 第三类数据
c=[-1.2 1.2 ];
S3=[.1 0 ;0 .1];
data3=mvnrnd(c,S3,100);
%显示数据
plot(data1(:,1),data1(:,2),'r+');
hold on;
plot(data2(:,1),data2(:,2),'b*');
plot(data3(:,1),data3(:,2),'go');
grid on;
 
%三类数据合成一个不带标号的数据类
data=[data1;data2;data3]; 
 
%K-means聚类
N=3;%设置聚类数目
[m,n]=size(data);
re=zeros(m,n+1);
center=zeros(N,n);%初始化聚类中心
re(:,1:n)=data(:,:);
for x=1:N
    center(x,:)=data( randi(300,1),:);%第一次随机产生聚类中心
end
while 1
distence=zeros(1,N);
num=zeros(1,N);
new_center=zeros(N,n);
 
for x=1:m
    for y=1:N
    distence(y)=norm(data(x,:)-center(y,:));%计算到每个类的距离
    end
    [~, temp]=min(distence);%求最小的距离
    re(x,n+1)=temp;         
end
k=0;
for y=1:N
    for x=1:m
        if re(x,n+1)==y
           new_center(y,:)=new_center(y,:)+re(x,1:n);
           num(y)=num(y)+1;
        end
    end
    new_center(y,:)=new_center(y,:)/num(y);
    if norm(new_center(y,:)-center(y,:))<0.1
        k=k+1;
    end
end
if k==N
     break;
else
     center=new_center;
end
end
[m, n]=size(re);
 
%最后显示聚类后的数据
figure;
hold on;
for i=1:m
    if re(i,n)==1 
         plot(re(i,1),re(i,2),'r+');
         plot(center(1,1),center(1,2),'ko');
    elseif re(i,n)==2
         plot(re(i,1),re(i,2),'b*');
         plot(center(2,1),center(2,2),'ko');
    elseif re(i,n)==3
         plot(re(i,1),re(i,2),'go');
         plot(center(3,1),center(3,2),'ko');
    else
         plot(re(i,1),re(i,2),'m*');
         plot(center(4,1),center(4,2),'ko');
    end
end
grid on
