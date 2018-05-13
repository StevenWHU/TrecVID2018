%
% Function: classify the 10000 cropped images accroding to the threshold for all
% detected face images
%
% Author: Chai Xiaoyu
% Date: 2018/5/7
%
clear all;clc;
%
%% initialization
% set file path
src_path = '/home/cj/project/tools_code/Trecvid/result_clean/';
img_path = '/home/cj/project/tools_code/Trecvid/example_image/';
save_path = '/home/cj/project/tools_code/Trecvid/img_check_3/';

all_len = 10000;

% get file number
file_dir = dir(cat(2,src_path,'*.mat'));
result_mat_num = size(file_dir,1);


%% set threshold intervals
thresholds = [0 30 50 70 80 90 100 120 150];
th_len = length(thresholds);

%% process every mat file in the folder
for result_count = 1:result_mat_num %start from the second mat
    result_count
    % generate file path
    result_file_path = cat(2,src_path,file_dir(result_count).name);
    % load file
    results = importdata(result_file_path);
    fprintf('The MAT file has been loaded successfully!\n');
    
    % acquire data
    all_results = results(1:all_len,:);% the top 10000 row in the file
    r_len = size(all_results,1);% get total number of faces
    
    info_img_height_tmp = all_results(:,3);% get height
    info_img_height = cell2mat(info_img_height_tmp);
    
    info_img_score_tmp = all_results(:,4);% get sililarity score
    info_img_score = cell2mat(info_img_score_tmp);
    
    %%
    % parsing thresholds and creating folders
%     mat_folder = cat(2,save_path,num2str(result_count,'%02d'),'/');
%     if ~exist(mat_folder)
%         mkdir(mat_folder);
%     end
    mat_folder = save_path;

    for th_count = 1:th_len
        if th_count ~= th_len
            th_inter = cat(2,num2str(thresholds(th_count)),'_',num2str(thresholds(th_count + 1)));
        else
            th_inter = cat(2,num2str(thresholds(th_count)),'_');
        end
        folder_path = cat(2,mat_folder,th_inter);
        
        if ~exist(folder_path)
            mkdir(folder_path);
            fprintf('create folder:%s\n',th_inter);
        end
    
    end
    
    %%
    % judge the value of height by threshold intervals
    %                                                                                                                                                       
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
        
        %%
        % proecess every row
        for row_count = 1:length(row)
            row_count
            obj_row = row(row_count,1);
            
            % genetate new image name
            img_file = all_results{obj_row,1};% get face image name
            img_score = all_results{obj_row,4};% get similarity score
            index_min = strfind(img_file,'#');
            index_max = strfind(img_file,'.');
            img_name = img_file(index_min + 1:index_max - 1);
%             new_img_name = cat(2,img_name,'#',num2str(img_score),'#','.jpg');
            new_img_name = cat(2,num2str(img_score),'#',img_name,'.jpg');

            % get face image ID
            face_ID_tmp = all_results{obj_row,6};% acquire face ID
            marks = strfind(face_ID_tmp,'_');
            face_ID = face_ID_tmp(1:min(marks)-1);

            src_full_path = cat(2,img_path,img_file);% generate image path
            dst_full_path = cat(2,mat_folder,dst_folder,'/',face_ID,'/');% generate save path
            
            % create new folder to save images if it dosen`t exist
            if ~exist(dst_full_path)
                mkdir(dst_full_path);
                fprintf('creating directory:\n%s\n',dst_full_path);
            end
            
            % copy coressponding image to the folder and rename the file           
            new_dst_full_path = cat(2,dst_full_path,new_img_name);
            copyfile(src_full_path,new_dst_full_path);

        end
        fprintf('Threshold:%d has processed!\n',thresholds(inter_count));

        % keep information
        save_info = cat(2,mat_folder,dst_folder,'.mat');
        save(save_info,'row');
        
        % reset to zero
        row = 0;
        clear results;
        
    end
    
end

%%
fprintf('Over!\n');