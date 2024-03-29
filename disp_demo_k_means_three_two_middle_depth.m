clc; clear all; close all;
filename='RGBD_r_13_422.jpg';
% filename='RGBD_R_2_619.jpg';
% filename='RGBD_R_2_588.jpg';
[token,~]=strtok(filename,'.');
filename_txt=[token '.txt'];
rootpath='recordData_process_annotation_sum/';
depthpath='depth_val/';
rgbpath='JPEGImages_val/';
labelpath='labels/';
filename_rgb=strcat(rootpath,rgbpath,filename);
filename_depth=strcat(rootpath,depthpath,filename);
filename_label=strcat(rootpath,labelpath,filename_txt);

%% 读取图片
I = imread(filename_depth);
I_rgb = imread(filename_rgb);
[h,w]=size(I);


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
x_hist_min=xmidd-hist_the;
y_hist_min=ymidd-hist_the;
x_hist_max=xmidd+hist_the;
y_hist_max=ymidd+hist_the;
I_bbox=I(ymin:ymax,xmin:xmax);
I_bbox_thr=I(y_hist_min:y_hist_max,x_hist_min:x_hist_max);
[h_bbox,w_bbox]=size(I_bbox_thr);
data = ones(3,h_bbox*w_bbox);

data_i=1;
for ht_j=1:h_bbox
    for ht_k=1:w_bbox
        data(:,data_i)=[ht_j,ht_k,I_bbox_thr(ht_j,ht_k)];
        data_i=data_i+1;
    end
end

[res, record] = ht_meanPolyD2(data,k,h_bbox,w_bbox);
[h, w] = size(res);
record_max=max(record);
[record_max_ind_r,record_max_ind_c]=find(record==record_max);
if mean(res(record_max_ind_c*3,1:record(record_max_ind_c)),2)<20
    depth_i=3-record_max_ind_c;
else
    depth_i=record_max_ind_c;
end
depth=round(mean(res(depth_i*3,1:record(depth_i)),2)/255*780);
%% 画出检测框
if depth<200
    state='dangerous';
    color=[255,0,0];
else
    state='safe';
    color=[0,255,0];

end
label_str = cell(1,1); 
label_str{1} = ['miner || depth: ' num2str(depth,'%3d') 'cm | state: ' state];

position = [xmin,ymin,bbox_w,bbox_h];

dest = insertObjectAnnotation(I, 'rectangle', position, label_str,'textboxopacity', 0.9, 'fontsize', 20,'LineWidth',8,'Color' ,color);
dest_rgb = insertObjectAnnotation(I_rgb, 'rectangle', position, label_str,'textboxopacity', 0.9, 'fontsize', 20,'LineWidth',8,'Color' ,color);

figure
subplot(1, 2, 1); imshow(dest, []); title('越界行为检测结果（深度图）','FontSize',25);
subplot(1, 2, 2); imshow(dest_rgb, []); title('越界行为检测结果（彩色图像）','FontSize',25);


