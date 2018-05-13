%
%Function: Information Integration
%Author: Chai Xiaoyu
%Data: 2018/04/09
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
%file length
file_len = 100000;
%
all_info = cell(0,5);

%%
% veriable initalization
face_file_row_len_all = 0;
score_file_row_len_all = 0;
%
all_face_infos = cell(0);
all_score_infos = cell(0);
%
% load all face data
for face_mat_count = 1:face_mat_num
    face_mat_count
    face_file_path = [face_info face_path(face_mat_count).name];
	face_infos = importdata(face_file_path);
    all_face_infos = [all_face_infos;face_infos];
    % acquire the row number
    face_file_row_len = size(face_infos,1);
    face_file_row_len_all = face_file_row_len_all + face_file_row_len;
    
end
% load all score data
for score_mat_count = 1:score_mat_num
    score_mat_count
    score_file_path = [score_info score_path(score_mat_count).name];
    score_infos = importdata(score_file_path);
    all_score_infos = [all_score_infos;score_infos];
    % acquire the row number
    score_file_row_len = size(score_infos,1);
    score_file_row_len_all = score_file_row_len_all + score_file_row_len;
    
end


%% total row number check
%score_mat_count
if face_file_row_len_all == score_file_row_len_all
    fprintf('total row number are CORRECT!\n');
else
    fprintf('something WRONG!\n');
    return;
end

%% save file
%
total_count = fix(face_file_row_len_all/file_len);

for save_count = 1:total_count
    save_count
    index_start = file_len*(save_count - 1) + 1;
    index_end = file_len*(save_count - 1) + file_len;
    
    all_info(1:file_len,1:3) = all_face_infos(index_start:index_end,1:3);
    all_info(1:file_len,4:5) = all_score_infos(index_start:index_end,2:3);
    
    save_path = [info_integration 'all_informaton_' num2str(save_count,'%02d') '.mat' ];
    save(save_path,'all_info');
    
    all_info = cell(0,5);
end

save_count = save_count + 1

index_start = file_len*(save_count - 1) + 1;
index_end = face_file_row_len_all;
    
all_info(1:index_end - index_start + 1,1:3) = all_face_infos(index_start:index_end,1:3);
all_info(1:index_end - index_start + 1,4:5) = all_score_infos(index_start:index_end,2:3);

save_path = [info_integration 'all_informaton_' num2str(save_count,'%02d') '.mat' ];
save(save_path,'all_info');

fprintf('Finished!\n');
