%
% Function: classify the cropped images accroding to the threshold
% Author: Chai Xiaoyu
% Date: 2018/4/26
%
clear all;clc;
%
%% initialization
% set file path
src_path = '/home/cj/project/tools_code/Trecvid/result_clean/result.mat';
img_path = '/home/cj/project/tools_code/Trecvid/example_image/';
save_path = '/home/cj/project/tools_code/Trecvid/img_check/';

% set threshold intervals
thresholds = [0 30 50 70 80 90 100 120 150];
th_len = length(thresholds);

% load file
all_results = importdata(src_path);
fprintf('The file has been loaded successfully!\n');

% acquire data
r_len = size(all_results,1);
info_img_height = all_results(:,3);
info_img_height = cell2mat(info_img_height);

%%
% parsing thresholds and creating folders
for th_count = 1:th_len
    if th_count ~= th_len
        th_inter = cat(2,num2str(thresholds(th_count)),'_',num2str(thresholds(th_count + 1)));
    else
        th_inter = cat(2,num2str(thresholds(th_count)),'_');
    end
    folder_path = cat(2,save_path,th_inter);
    if ~exist(folder_path)
        mkdir(folder_path);
        fprintf('create folder:%s\n',th_inter);
    end
    
end

%%
% judge the value of height by threshold intervals
for inter_count = 1:th_len
    inter_count
    % generating row and folders
    if inter_count ~= th_len
        [row, ~] = find(info_img_height >= thresholds(inter_count) & info_img_height < thresholds(inter_count + 1)); 
        dst_folder = cat(2,num2str(thresholds(inter_count)),'_',num2str(thresholds(inter_count + 1)));
    else
        [row, ~] = find(info_img_height >= thresholds(inter_count)); 
        dst_folder = cat(2,num2str(thresholds(inter_count)),'_');
    end
    
    % proecess every row
    for row_count = 1:length(row)
        row_count
        img_file = all_results{row_count,1};% acquire face image name
        face_ID_tmp = all_results{row_count,6};% acquire face ID
        marks = strfind(face_ID_tmp,'_');
        face_ID = face_ID_tmp(1:min(marks)-1);
        
        src_full_path = cat(2,img_path,img_file);% generate image path
        dst_full_path = cat(2,save_path,dst_folder,'/',face_ID,'/');% generate save path
        if ~exist(dst_full_path)
            mkdir(dst_full_path);
            fprintf('creating directory:\n%s\n',dst_full_path);
        end
        copyfile(src_full_path,dst_full_path);       
        
    end
    fprintf('Threshold:%d has processed!\n',thresholds(inter_count));
    
    % keep information
    save_info = cat(2,save_path,dst_folder,'.mat');
    save(save_info,'row');
    % reset to zero
    row = 0;
    
end
% 
%%
fprintf('Over!\n');