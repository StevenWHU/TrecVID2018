%
%Function: Information Integration
%Author: Chai Xiaoyu
%Data: 2018/04/08
%
%
clear,clc;
%%
%initialization data path
face_info = '/home/cj/project/tools_code/Trecvid/face_mat/';
score_info = '/home/cj/project/tools_code/Trecvid/similarity_score/';
info_integration = '/home/cj/project/tools_code/Trecvid/info_integration/';
%
face_path = dir([face_info '*.mat']);
score_path = dir([score_info '*.mat']);
% acquire file number
face_mat_num = length(face_path);
score_mat_num = length(score_path);
% acquire filename
face_dircell = struct2cell(face_path)';
face_filenames = face_dircell(:,1);
score_dircell = struct2cell(score_path)';
score_filenames = score_dircell(:,1);

%save length
save_len = 10000;
%file length
file_len = 100000;
%
all_info = cell(0,5);

%% total row number check
% %total row number check
% face_file_row_len_all = 0;
% score_file_row_len_all = 0;
% % face row number
% for face_mat_count = 1:face_mat_num
%     face_mat_count
%     face_file_path = [face_info face_path(face_mat_count).name];
% 	face_infos = importdata(face_file_path);
%     face_file_row_len = size(face_infos,1);%acquire the row number
%     face_file_row_len_all = face_file_row_len_all + face_file_row_len;
%     
% end
% % score row number
% for score_mat_count = 1:score_mat_num
%     score_mat_count
%     score_file_path = [score_info score_path(score_mat_count).name];
%     score_infos = importdata(score_file_path);
%     score_file_row_len = size(score_infos,1);%acquire the row number
%     score_file_row_len_all = score_file_row_len_all + score_file_row_len;
%     
% end
% %score_mat_count
% if face_file_row_len_all == score_file_row_len_all
%     fprintf('total row number are CORRECT!\');
% else
%     fprintf('something WRONG!\');
% end

%% construct score file path cell
% score row number
for score_mat_count = 1:score_mat_num
    score_file_path = [score_info score_path(score_mat_count).name];
    score_info_path_cell{score_mat_count,1} = score_file_path;
    
end

%% integrating information
score_file_count = 1;
score_row_index = 0;
all_info_index = 0;
% import facedata
for face_mat_count = 1:face_mat_num
    face_mat_count
    face_file_path = [face_info face_path(face_mat_count).name];
	face_infos = importdata(face_file_path);
    face_file_row_len = size(face_infos,1);%acquire the row number
    all_info = face_infos;
    
    score_content = importdata(score_info_path_cell{score_file_count});
    score_col = size(score_content,1);%acquire the row number
    all_info_index = score_col;
    all_info(1:all_info_index,4:5) = ...
        score_content(score_row_index + 1:score_col,2:3);
    
    left_all_info_row = face_file_row_len - all_info_index;
    
%     if left_all_info_row >= 100000 
%         score_file_count = score_file_count + 1;
%         score_content = importdata(score_info_path_cell{score_file_count});
%         score_col = size(score_content,1);
%         all_info_index = score_col;
%         all_info(all_info_index + 1:all_info_index + score_col,4:5) = ...
%             score_content(:,2:3);
%     else
%         score_row_index = face_file_row_len-all_info_index+1;
%         all_info(all_info_index + 1:face_file_row_len,4:5) = ...
%             score_content(1:score_row_index,2:3);
%     end
    count = 1;
    while(left_all_info_row >= 100000 )
        score_file_count = score_file_count + 1;
        score_content = importdata(score_info_path_cell{score_file_count});
        score_col = size(score_content,1);
        all_info_index = score_col;
        all_info(all_info_index + 1:all_info_index + score_col,4:5) = ...
            score_content(:,2:3);
        
        left_all_info_row = left_all_info_row - 100000;
        count = count + 1;
    end
    
    score_row_index = left_all_info_row;
    all_info(all_info_index*count + 1:face_file_row_len,4:5) = ...
        score_content(1:score_row_index,2:3);
        
%     for score_mat_count = 1:score_mat_num
%         score_file_path = [score_info score_path(score_mat_count).name];
%         score_infos = importdata(score_file_path);
%         score_file_row_len = size(score_infos,1);%acquire the row number
%         
%     end
    
end
