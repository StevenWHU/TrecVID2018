clc;clear all;

path_org = '/home/cj/project/tools_code/Trecvid/2018_topic/face_mat/topic_size.mat';
path_resized = '/home/cj/project/tools_code/Trecvid/2018_topic/face_mat_resize/topic_size_resize.mat';

old = importdata(path_org);
new = importdata(path_resized);

len = size(old,1);

   
% img name
name(:,1) = old(:,1);

old_h(:,1) = old(:,2);

new_h(:,1) = new(:,2);

all_results = cat(2,name,old_h,new_h);

save_path = '/home/cj/project/tools_code/Trecvid/2018_topic/face_mat_resize/all_results.mat';
save(save_path,'save_path');