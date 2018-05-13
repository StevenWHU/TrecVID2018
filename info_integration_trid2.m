%
%Function: Information Integration
%Author: Chai Xiaoyu
%Data: 2018/04/08
%
%
clear,clc;
%%
%
%initialization data path
%
face_info = '/home/cj/project/tools_code/Trecvid/face_mat/';
score_info = '/home/cj/project/tools_code/Trecvid/similarity_score/';
info_integration = '/home/cj/project/tools_code/Trecvid/info_integration/';
%
face_path = dir([face_info '*.mat']);
score_path = dir([score_info '*.mat']);
%
% acquire file number
%
face_mat_num = length(face_path);
score_mat_num = length(score_path);
%
% acquire filename
%
face_dircell = struct2cell(face_path)';
face_filenames = face_dircell(:,1);
score_dircell = struct2cell(score_path)';
score_filenames = score_dircell(:,1);
%
%save length
save_len = 10000*2;
%file length
file_len = 100000;
%
save_index = 1;
%
all_info = cell(0,3);

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
total_score_info = cell(0);

%% load all score file
%
for score_mat_count = 1:2%score_mat_num
    score_mat_count
    score_file_path = [score_info score_path(score_mat_count).name];
    total_score_info = [total_score_info;importdata(score_file_path)];
    
end

%% integrating information
%
all_info_index = 0;
total_score_info_start = 1;
total_score_info_end = 0;
%
% import facedata
for face_mat_count = 1:face_mat_num
    face_mat_count
    face_file_path = [face_info face_path(face_mat_count).name];
	face_infos = importdata(face_file_path);
    face_file_row_len = size(face_infos,1);%acquire the row number
    face_file_row_len = face_file_row_len/10;
%     all_info = face_infos;% first three colume
    
    all_info_index = face_file_row_len;
    total_score_info_start = total_score_info_end + 1;
    total_score_info_end = total_score_info_start + face_file_row_len - 1;
    all_info(1:all_info_index,1:3) = total_score_info(total_score_info_start:total_score_info_end,1:3);
    
   
    %% save file
    save_path = [info_integration 'all_informaton_' num2str(face_mat_count,'%02d') '.mat' ];
    save(save_path,'all_info');
    
    for save_count = 1:fix(face_file_row_len/save_len)
        save_count
        start_row = save_len*(save_count - 1) + 1;
        end_row = save_len*(save_count - 1) + save_len; 
%         save_part = all_info(start_row:end_row,:);
        save_part = all_info(1:end_row,:);
        save(save_path,'save_part', '-v7.3');
    end
    %
    start_row = end_row + 1;
    end_row = face_file_row_len;
    save_part = all_info(1:end_row,:);
    save(save_path,'save_part');
%     save_path = [info_integration 'all_informaton-' num2str(face_mat_count,'%2d') '.mat' ];
%     save(save_path,'all_info');
    % reset to zero
    all_info = cell(0,3);
    start_row = 1;
    end_row = 0;
    save_part = cell(0);
    
end
