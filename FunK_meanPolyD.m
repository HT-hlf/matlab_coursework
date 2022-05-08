function [ res, record] = FunK_meanPolyD(data,k )
% ���ܣ�
%     ʵ�ֶ�ά�ռ�k-mean�����㷨
% ���룺
%     data��d*n���ľ�������d����ά�ȣ�n��������������
%     k �Ƿֳɵ���������
% �����
%     res ������Ϊ(d*k), ����Ϊrecord�����Ԫ��ֵ
%	  ����res������Ϊd*k�Ľ��ͣ� 
%		1:d �Ƕ�Ӧ�ŵ�һ���Ԫ��
%		d+1:2*d �Ƕ�Ӧ�ŵڶ����Ԫ�� 
%			������ 
%		d*(k-1)+1:d*k �Ƕ�Ӧ�ŵ�k���Ԫ��
%
%     record���Ϊ1*k,��¼��ÿһ������ЧԪ�صĸ���

    j = 1;
    % ������Ԥ����һЩ�ռ�
    % seedX �� seedY �д������������
    [h w] = size(data);
    cnt = w; % ����Ԫ�ص�����
    cntOfDimension = h; % d �д���ű��δ������ݵ�ά��
    %seed �д�����ӣ�ÿһ�д����������ڵ�һ��ά�ȣ�ÿһ����һ����������
    seed = zeros(cntOfDimension,k);
    oldSeed = zeros(cntOfDimension,k);
    % �������res�У����ݴ�Ź���
    %   ��d��Ϊһ����λ���ܹ�k��d��
    %   ��һ��d�����ݴ���ŵ�һ��Ԫ�ؼ���,����ͬ��
    res = zeros(k*cntOfDimension,cnt); 
    % ������¼resX��ÿһ����ЧԪ�صĸ���
    record = zeros(1,k); 
    r = 0;
    for i = 1:k % ����k���������, ע�⣺ �������������Ԫ�ؼ���
        t = round(rand()*cnt);
        % Ϊ��֤���Ӳ��ص�
        if i > 1 && t == r
            i = i - 1;
            continue;
        end
        
        seed(:,i) = data(:,t);
        r = t;
    end
    ht_count=1;
    while 1
        record(:) = 0; % ����Ϊ��
        res(:) = 0;
        for i = 1:cnt % ������Ԫ�ر���
            % �������жϱ���Ԫ��Ӧ�ù�Ϊ��һ�࣬���������Ǹ���ŷ����þ����������ж�
            % k-mean�㷨��ΪԪ��Ӧ�ù�Ϊ������������Ӵ������
            distanceMin = 1; % distanceMin �д�������ŷ����þ�������ӵ���±�
            for j = 2:k
                % �����ά�ȵ�ŷ����þ���
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
            % ������Ԫ�ص�������鲢
            row = (distanceMin-1)*cntOfDimension + 1;
            res(row:row+cntOfDimension-1,record(distanceMin)+1) = data(:,i);
            record(distanceMin) = record(distanceMin)+1;
        end
        %record
        oldSeed = seed;
        % �ƶ���������������
        for col = 1:k
            if record(col) == 0
                continue;
            end
            % �����µ�����λ��
            row = (col-1)*cntOfDimension + 1;
            seed(:,col) = sum(res(row:row+cntOfDimension-1,:),2)/record(col);
        end
        % ������εõ������Ӻ��ϴε�����һ�£�����Ϊ������ϡ�
        if mean(seed == oldSeed) == 1
            break;
        end
        figure
        ht_color=['r*';'g*';'b*';'k*'];
        
        for i = 1:k
        plot3(res(i*3-2,1:record(i)),res(i*3-1,1:record(i)),res(i*3,1:record(i)),'*')
        plot3(mean(res(i*3-2,1:record(i)),2),mean(res(i*3-1,1:record(i)),2),mean(res(i*3,1:record(i)),2),'Marker','square','Color','k','MarkerFaceColor','k','LineStyle','none')
        title(['����',num2str(ht_count),'��֮������ݵ�'],'FontSize',15);
        hold on%ע�⣺hold on Ҫд��plot3֮��������άͼ�βŻ���������
        end
        ht_count=ht_count+1;
    end
    
    maxPos = max(record);
    res = res(:,1:maxPos);
end
