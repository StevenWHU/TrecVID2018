%
%Function: Information Integration
%Author: Chai Xiaoyu
%Data: 2018/04/25
%
%
clear,clc;
%%
%
% initialization data path
%
mat_path = '/home/cj/project/tools_code/Trecvid/info_integration/';
save_path = '/home/cj/project/tools_code/Trecvid/result_clean/';

% get file number
file_dir = dir(cat(2,mat_path,'*.mat'));
info_mat_num = size(file_dir,1);

%% process every mat file in the folder
for info_count = 6:info_mat_num %start from the second mat
    info_count
    % get file path
    mat_file_path = cat(2,mat_path,file_dir(info_count).name);
    all_info = importdata(mat_file_path);

    matlen = size(all_info,1);
    index = 1;

    info_croped_img = cell(0);
    info_reference_img = cell(0);
    info_id_prediction = cell(0);

    info_img_width = ones(0);
    info_img_height = ones(0);
    info_reference_score = ones(0);
    
    info_img_width_cell = cell(0);
    info_img_height_cell = cell(0);
    info_reference_score_cell = cell(0);
    
    for count = 1:matlen
        count
        % conmpute detected face number
        cropped_face = all_info{count,4};
        dectected_face_num = size(cropped_face,1);
        % 
        if dectected_face_num == 0
            continue;
        else
            % process every detected face in the keyframes
            for face_count = 1:dectected_face_num
                % landmakrk coordinates
                x1 = all_info{count,2}{1,1}(face_count,1);
                y1 = all_info{count,2}{1,1}(face_count,2);
                x2 = all_info{count,2}{1,1}(face_count,3);
                y2 = all_info{count,2}{1,1}(face_count,4);
                % five key information
                croped_img_tmp = all_info{count,4}{face_count,1};    
                croped_img = cell2mat(croped_img_tmp);% cropped image path

                img_width = x2 - x1; % cropped image width
                img_height = y2 - y1; % cropped image height
                reference_img_tmp = all_info{count,5}{face_count,1}{1,1};% reference image path 
                reference_score = all_info{count,5}{face_count,1}{1,2};% reference image scroe
                % acquire id_prediction
                reference_img = cell2mat(reference_img_tmp);
                index_start = strfind(reference_img,'#');
                index_end = strfind(reference_img,'.');
                id_prediction = reference_img(index_start + 1: index_end - 1);% prediction id
                % save correspoding data
                info_croped_img{index,1} = croped_img;
                info_img_width(index,1) = img_width;
                info_img_height(index,1) = img_height;
                info_reference_score(index,1) = reference_score;
                info_reference_img{index,1} = reference_img;
                info_id_prediction{index,1} = id_prediction;
                % 
                index = index + 1;
            end

        end

    end
    % matrix format trasnformation
    info_img_width_cell = num2cell(info_img_width);
    info_img_height_cell = num2cell(info_img_height);
    info_reference_score_cell = num2cell(info_reference_score);

    % contacnate all information(six column)
    all_results = cat(2,info_croped_img,info_img_width_cell,...
        info_img_height_cell,info_reference_score_cell,...
        info_reference_img,info_id_prediction);
    % save result
    save_result_path = cat(2,save_path, 'result-', num2str(info_count,'%02d'),'.mat');
    save(save_result_path, 'all_results');
    
    
end



fprintf('Over!\n');