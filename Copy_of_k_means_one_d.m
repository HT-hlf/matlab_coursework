% ����K-��ֵ�����ԭ����ʵ�ֶ�һ�����ݵķ��ࡣ������һ��һά�ĵ�Ϊ���� 14 ���� , ���������� , �����ݼ��ֳ� 3 �� ;
clc;clear;
X=[1,3,5,8,9,11,12,13,37,43,45,49,51,65];
N = length(X); % ��ĸ���
Y=ones(1,N);%Ϊ�˱��ڱ�ʾһά���ݾ����������y����ͳһ��1�������ڶ�άͼ�ϵ�����
%% ����ԭʼ���ݵ㣬�������5�д��롣��չ��ѡ�и�5�д��룬ctrl+t��ȥ��%����ctrl+r�ɿ��ټ���ע��%
% % % figure(1)
% % % plot(X, Y, 'r*'); % ���ԭʼ�����ݵ�
% % % xlabel('X');
% % % ylabel('Y');
% % % title('����֮ǰ�����ݵ�');
%%
K = 3; %�����е����ݵ��Ϊ3�࣬Ϊ�˱��ڱ��ĵ���������չ������K����û���õ��������Լ���������K������ϲ����Ӷ���Ӧ�������������
n = 3; %�����е����ݵ��Ϊ3��
m = 1; %�������������ڽ��������ĵĳ�ʼֵ��Ϊ1�ε������������m��ʼֵΪ1�����Ժ��������������ʱ����Ҫ��1��
eps = 1e-7; % ������������ֵ
%% ����������е�ȡֵ������ͬ��Ҳ�������ѡȡ��������
u1 = [1,1]; %��ʼ����һ����������
u2 = [20,1]; %��ʼ���ڶ�����������
u3 = [40,1]; %��ʼ����������������
% % % %% ���ѡȡ����������4�д���Ϊ�����������ѡȡ3������
% % % suiji=randperm(14,3);  %  p = randperm(n,k) ���������������а����� 1 �� n ֮�����ѡ��� k ��Ψһ������
% % %                        %  ��չ��p = randperm(n) ���������������а����� 1 �� n û���ظ�Ԫ�ص�����������С�
% % % u1=[X(suiji(1)),Y(suiji(1))];%ע�����һά��Y��ʾ��ͬһ������Ĺ̶���ֵ��Y����ֵ����
% % % u2=[X(suiji(2)),Y(suiji(2))];
% % % u3=[X(suiji(3)),Y(suiji(3))];
%%
U1 = zeros(2,50);%U1,U2��U3���ڴ�Ÿ��ε���3���������ĵĺ�������
U2 = zeros(2,50); 
U3 = zeros(2,50);
 
U1(:,2) = u1; %������Ҫ�����ε�����ֵ������U1�ӵڶ��п�ʼ��ֵ
U2(:,2) = u2;
U3(:,2) = u3;
D = zeros(n,N); %��ʼ�����ݵ���������ĵľ���
 
while(abs(U1(1,m) - U1(1,m+1)) > eps || abs(U2(1,m) - U2(1,m+1)) > eps ||  abs(U3(1,m) - U3(1,m+1)) > eps )%��һ�ε�����ľ�������ֵ�뱾�ε����Ĳ�ֵ��
   %��һ�д����У� m=1ʱ��ʾ0���ʼֵ�Ĳ�ֵ��U1(1,m+1)ʵ�ʱ�ʾ��m-1�ֵ��������������ֵ���
    m = m +1;
%% �������е㵽3���������ĵľ���
for i = 1 : N
    D(1,i) = abs(X(i) - U1(1,m));%���㵽���ĵľ���,abs����ֵ����
end
for i = 1 : N
    D(2,i) = abs(X(i) - U2(1,m));
end
for i = 1 : N
    D(3,i) = abs(X(i) - U3(1,m));
end
%%
A = zeros(2,N); % A���ڴ�ŵ�һ������ݵ�
B = zeros(2,N); % B���ڴ�ŵڶ�������ݵ�
C = zeros(2,N); % C���ڴ�ŵ���������ݵ�
for k = 1: N
    [MIN,index] = min(D(:,k)); %MIN������¼A��ÿ�е���Сֵ��index������¼ÿ����Сֵ���к�
    if index == 1             % �����ڵ�һ����������
        A(1,k) = X(k);
        A(2,k) = Y(k);
    else
        if   index == 2       % �����ڵڶ�����������
        B(1,k) = X(k);
        B(2,k) = Y(k);
        else                  % �����ڵ�������������
        C(1,k) = X(k);
        C(2,k) = Y(k);
        end
    end
end
indexA = find(A(1,:) ~= 0); % �ҳ���һ���еĵ�,~=��ʾ������0
indexB = find(B(1,:) ~= 0); % �ҳ��ڶ����еĵ�
indexC = find(C(1,:) ~= 0); % �ҳ��������еĵ�
 
%% ������6�и��������ľ������ģ���������6����Ϊ����֤�����ṩ���Ƶ�����
U1(1,m+1) = mean(A(1,indexA));% ����������������
U1(2,m+1) = mean(A(2,indexA));
U2(1,m+1) = mean(B(1,indexB));
U2(2,m+1) = mean(B(2,indexB));
U3(1,m+1) = mean(C(1,indexC));
U3(2,m+1) = mean(C(2,indexC));
 
%% ���ӵĲ�����Ϊ�˱����Ƶ������⣬���ڼ�����ֵ��ȡ����������Ϊ�µľ�������ֵ������7�д����������㷽��ȡ������ֵ��Ϊ�������ġ�
%���������������ġ�����mean��ʾ������ƽ��ֵ�ĺ�����fix��ʾ���㷽��ȡ������չ��ceil���������ȡ����round��������ȡ����
% U1(1,m+1) =fix(mean(A(1,indexA)));
% U1(2,m+1) =fix(mean(A(2,indexA)));
% U2(1,m+1) =fix(mean(B(1,indexB)));
% U2(2,m+1) =fix(mean(B(2,indexB)));
% U3(1,m+1) =fix(mean(C(1,indexC)));
% U3(2,m+1) =fix(mean(C(2,indexC)));
%%
juleizhongxin=[U1(1,m+1),U2(1,m+1),U3(1,m+1)];%����������
disp(['��ǰ�����Ĵ���Ϊ:',num2str(m)-1]);
disp(['���º�ľ���������:',num2str(juleizhongxin)]);
%%
% % % figure(m-1);%ÿ�ε����Ľ����ͼ����ֻ���յ������������ⲿ�ִ���ŵ����figure(m)�ĳ�figure
% % % plot(A(1,indexA) , A(2,indexA), '*b'); % ������һ����ͼ��
% % % hold on
% % % plot(B(1,indexB) , B(2,indexB), 'or'); %�����ڶ�����ͼ��
% % % hold on
% % % plot(C(1,indexC) , C(2,indexC), 'dk'); %������������ͼ��
% % % hold on
% % % 
% % % centerx = [U1(1,m+1) U2(1,m+1)  U3(1,m+1)];%��������
% % % centery = [U1(2,m+1) U2(2,m+1)  U3(2,m+1)];
% % % 
% % % plot(centerx , centery, '+g'); % ����ÿ�ε����ľ������ĵ�
% % % xlabel('X');
% % % ylabel('Y');
% % % title('����֮������ݵ�');
 
end
%% ��ͼ �ò�ͬ��ɫ��ʾ����ĵ�
figure(8);
plot(A(1,indexA) , A(2,indexA), '*b'); % �������ڵ�һ����ͼ��
hold on
plot(B(1,indexB) , B(2,indexB), 'or'); %�������ڵڶ�����ͼ��
hold on
plot(C(1,indexC) , C(2,indexC), 'dk'); %�������ڵ�������ͼ��
hold on
 
centerx = [U1(1,m) U2(1,m)  U3(1,m)];
centery = [U1(2,m) U2(2,m)  U3(2,m)];
 
plot(centerx , centery, '+g'); % �������յľ������ĵ�
xlabel('����/��');
ylabel('Y');
title('����֮������ݵ�');
% % disp(['������������ֹ�����Ĵ���Ϊ:',num2str(m)-1]);
%% ������ʾ��ʽ
nameqianzhui='������С��ֵ���ڵ�';
diedai=m-1;
% % disp(sprintf('%s %d �ε�������ֹ',nameqianzhui,diedai));
fprintf('%s %d �ε�������ֹ\n',nameqianzhui,diedai);
 