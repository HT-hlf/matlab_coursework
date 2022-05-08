clc; clear all; close all;
filename='RGBD_R_2_588.jpg';
[token,~]=strtok(filename,'.');
filename_txt=[token '.txt'];
rootpath='recordData_process_annotation_sum/';
depthpath='depth_val/';
labelpath='labels/';
% filename1=[rootpath filename];
filename_depth=strcat(rootpath,depthpath,filename);
filename_label=strcat(rootpath,labelpath,filename_txt);
% fprintf(filename_txt);

%% 读取图片
I = imread(filename_depth);
[h,w]=size(I);
% I=I(200:250,200:250)
% [J,T] = histeq(I);
figure; 
subplot(2, 3, 1); imshow(I, []); title('原图');
% subplot(2, 3, 2); imshow(J, []); title('原图均衡化后的图像');
% subplot(2, 3, 3); imhist(I, 64); title('原图的直方图');
% subplot(2, 3, 4); imhist(J, 64); title('均衡化后的直方图');
%% 读取txt文件中的预测框
fid=fopen(filename_label);
if fid==-1
    disp('File open not successful');
else
   while feof(fid)==0
              aline=fgetl(fid);
              bbox=[];
              for i=1:5
                  [token,aline]=strtok(aline);
                  bbox=[bbox str2double(token)];
              end
   end 
   closeresult=fclose(fid);
   if closeresult==0
        disp('File close sucessful');
   else
       disp('File close not sucessful');
   end
end
hist_the=16;
xmidd=round(bbox(2)*w);
ymidd=round(bbox(3)*h);
bbox_w=round(bbox(4)*w);
bbox_h=round(bbox(5)*h);
xmin=round(xmidd-bbox_w/2);
ymin=round(ymidd-bbox_h/2);
xmax=round(xmidd+bbox_w/2);
ymax=round(ymidd+bbox_h/2);
% [xmin ymin xmax ymax];
x_hist_min=xmidd-hist_the;
y_hist_min=ymidd-hist_the;
x_hist_max=xmidd+hist_the;
y_hist_max=ymidd+hist_the;
% xmin=418;
% ymin=277;
% xmax=492;
% ymax=424;
I_bbox=I(ymin:ymax,xmin:xmax);
I_bbox_thr=I(y_hist_min:y_hist_max,x_hist_min:x_hist_max);
% I_bbox_thr_one_d=I_bbox_thr(:);
subplot(2, 3, 2); imshow(I_bbox); title('检测到的矿工');
% [yout,x]=imhist(I_bbox, 5)
% subplot(2, 3, 4); imhist(I_bbox, 5); title('原图的直方图');
subplot(2, 3, 3); imshow(I_bbox_thr, []); title('矿工检测框中的中间某一阈值');
[yout,x]=imhist(I_bbox_thr, 5);
yout=yout';
x=x';
yout_max=max(yout);
[yout_max_ind_r,yout_max_ind_c]=find(yout==yout_max);
x(yout_max_ind_c)
depth=round(x(yout_max_ind_c)/255*780);
fprintf('depth:%d\n',depth);
subplot(2, 3, 4); imhist(I_bbox_thr, 5); title('原图的直方图');
%% 画出检测框
if depth<200
%     dest=drawRect( I, [xmin,ymin], [bbox_w,bbox_h],4, [255,0,0] );
    state='dangerous';
    color=[255,0,0];
else
%     dest=drawRect( I, [xmin,ymin], [bbox_w,bbox_h],4, [0,255,0] );
    state='safe';
    color=[0,255,0];

end
label_str = cell(1,1); 
label_str{1} = ['miner || depth: ' num2str(depth,'%3d') 'cm | state: ' state];


position = [xmin,ymin,bbox_w,bbox_h];

dest = insertObjectAnnotation(I, 'rectangle', position, label_str,'textboxopacity', 0.9, 'fontsize', 20,'LineWidth',8,'Color' ,color);

% figure, imshow(rgb), title('annotated chips');

subplot(2, 3, 5); imshow(dest, []); title('矿工检测框');
[h_bbox,w_bbox]=size(I_bbox_thr);
data = ones(3,h_bbox*w_bbox);
% t = 2000;
% d = 3;
% data = rand(d,t);
data_i=1;
for ht_j=1:h_bbox
    for ht_k=1:w_bbox
        data(:,data_i)=[ht_j,ht_k,I_bbox_thr(ht_j,ht_k)];
        data_i=data_i+1;
    end
end
% a=power(power(power(data(1,i)-h_bbox/2,2)+power(data(2,i)-w_bbox/2,2),0.5)-seed(1,distanceMin),2)+power(data(3,i)-seed(3,distanceMin),2);
%                   power(power(data(1,i)-h_bbox/2,2)+power(data(2,i)-w_bbox/2,2),0.5)
%                   h_bbox=0,w_bbox=0
k=10;
% [res, record] = ht_meanPolyD(data,k);
[res, record] = ht_meanPolyD(data,k,h_bbox,w_bbox);
figure
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



