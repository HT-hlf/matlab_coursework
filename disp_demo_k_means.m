clc; clear all; close all;
% filename='RGBD_r_13_422.jpg';
% filename='RGBD_R_2_619.jpg';
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
subplot(1, 3, 1); imshow(I, []); title('深度图','FontSize',25);
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
I_bbox_thr_one_d=I_bbox_thr(:);
subplot(1, 3, 2); imshow(I_bbox); title('检测到的矿工','FontSize',25);
% [yout,x]=imhist(I_bbox, 5)
% subplot(2, 3, 4); imhist(I_bbox, 5); title('原图的直方图');
subplot(1, 3, 3); imshow(I_bbox_thr, []); title('矿工检测框中的中间某一阈值','FontSize',25);
[yout,x]=imhist(I_bbox_thr, 5);
yout=yout';
x=x';
yout_max=max(yout);
[yout_max_ind_r,yout_max_ind_c]=find(yout==yout_max);
x(yout_max_ind_c)
depth=round(x(yout_max_ind_c)/255*780);
fprintf('depth:%d\n',depth);
% subplot(2, 3, 4); imhist(I_bbox_thr, 5); title('原图的直方图');
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

% subplot(2, 3, 5); imshow(dest, []); title('矿工检测框');
miner_depth_k_means(I_bbox_thr_one_d)


