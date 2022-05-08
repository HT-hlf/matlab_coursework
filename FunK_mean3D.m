function [ resX,resY, resZ,record] = FunK_mean3D( x,y,z,k )
% ���ܣ�
%     ʵ����ά�ռ�k-mean�����㷨
% ���룺
%     ��ά���ݣ��ֱ���x,y,z����һά������������ά��
%     k �Ƿֳɵ���������
% �����
%     k�е���������
%     ��Ӧͬ���ĵ�n�У�����ŵ�n�������Ԫ��
%     record: ��¼��ÿһ�е���ЧԪ�صĸ���

    j = 1;
    % ������Ԥ����һЩ�ռ�
    % seedX �� seedY �д������������
    seedX = zeros(1,k);
    seedY = zeros(1,k);
    seedZ = zeros(1,k);
    oldSeedX = zeros(1,k);
    oldSeedY = zeros(1,k);
    oldSeedZ = zeros(1,k);
    resX = zeros(k,length(x));
    resY = zeros(k,length(x));
    resZ = zeros(k,length(x));
    % ������¼resX��ÿһ����ЧԪ�صĸ���
    record = zeros(1,k); 
    for i = 1:k % ����k���������, ע�⣺ �������������Ԫ�ؼ���
        seedX(i) = x(round(rand()*length(resX)));
        seedY(i) = y(round(rand()*length(resX)));
        seedZ(i) = z(round(rand()*length(resX)));
        % Ϊ��֤���Ӳ��ص�
        if (i > 1 && seedX(i) == seedX(i-1) && seedY(i) == seedY(i-1) && seedZ(i) == seedZ(i-1))
            i = i -1; % ���²���һ������
        end
    end
    
    while 1
        record(:) = 0; % ����Ϊ��
        resX(:) = 0;
        resY(:) = 0;
        resZ(:) = 0;
        for i = 1:length(x) % ������Ԫ�ر���
            % �������жϱ���Ԫ��Ӧ�ù�Ϊ��һ�࣬���������Ǹ���ŷ����þ����������ж�
            % k-mean�㷨��ΪԪ��Ӧ�ù�Ϊ������������Ӵ������
            distanceMin = 1;
            for j = 2:k
                if (power(x(i)-seedX(distanceMin),2)+power(y(i)-seedY(distanceMin),2)+power(z(i)-seedZ(distanceMin),2))... 
                    > (power(x(i)-seedX(j),2) + power(y(i)-seedY(j),2)+power(z(i)-seedZ(j),2))
                    distanceMin = j;
                end
            end
            % ������Ԫ�ص�������鲢
            resX(distanceMin,record(distanceMin)+1) = x(i);
            resY(distanceMin,record(distanceMin)+1) = y(i);
            resZ(distanceMin,record(distanceMin)+1) = z(i);
            record(distanceMin) = record(distanceMin) + 1;
        end
        oldSeedX = seedX;
        oldSeedY = seedY;
        oldSeedZ = seedZ;
        % �ƶ���������������
        record
        for i = 1:k
            if record(i) == 0
                continue;
            end
            seedX(i) = sum(resX(i,:))/record(i);
            seedY(i) = sum(resY(i,:))/record(i);
            seedZ(i) = sum(resZ(i,:))/record(i);
        end
        
        % ������εõ������Ӻ��ϴε�����һ�£�����Ϊ������ϡ�
        
        if mean([seedX == oldSeedX seedY == oldSeedY seedZ == oldSeedZ]) == 1 % ��仰���������˼���� if seedX == oldSeedX && seedY == oldSeedY
            break;
        end
    end
    
    maxPos = max(record);
    resX = resX(:,1:maxPos);
    resY = resY(:,1:maxPos);
    resZ = resZ(:,1:maxPos);
end


