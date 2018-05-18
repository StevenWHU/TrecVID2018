%
%
%Function: add some new information to the topic_person_find.trid.mat
%Author: Chai Xiaoyu
%Data: 2018/05/16
%
%
clear,clc;
%%
%
%initialization data path
%
info_path = '/home/cj/project/tools_code/Trecvid/result_clean_v4/';
person_path = '/home/cj/project/tools_code/Xiaoyu/topic_person_find/actor_order.txt';

src_path = '/home/cj/project/tools_code/Trecvid/example_image/';
dst_path = '/home/cj/project/tools_code/Trecvid/result_clean_v5/';

% threshold
H = 80;
S = [0.61,0.63,0.65,0.7];

% read file
face_info = dir(cat(2,info_path,'*mat'));
txtread = fopen(person_path,'r');
file_content = textscan(txtread,'%s%d');

% file number
mat_num = size(face_info,1);
person_num = size(file_content{1,2},1);

%%
% create person folder
% for persons = 1:person_num
%     folder_name = cat(2,num2str(file_content{1,2}(persons)),'_',file_content{1,1}{persons});
%     folder_path =  cat(2,dst_path,folder_name,'/');
%     if ~exist(folder_path)
%         mkdir(folder_path);
%         fprintf('creating folder:\n%s\n',folder_path);
%     end
%     person_matrix{persons,1} =  folder_path;
%     
% end

%%
% process every mat file
for mat_count = 1:mat_num
    mat_count
    % load mat file
    mat_name = face_info(mat_count).name;
    mat_path = cat(2,info_path,mat_name);
    top1_face_info = importdata(mat_path);
    
    % initilize empty matrix 
    row_num = size(top1_face_info,1);
    info = zeros(row_num,1);
    
    % process every person
    for person_count = 1:1%person_num
        person_count
        
%         % CONDITION-1:find corresponding person
%         person_ID = file_content{1,2}(person_count);% get the topic person ID
%         [row_ID,~] = find(top1_face_info(:,9) == person_ID);% get the corressponding row in mat file
        
        % CONDITION-2:find corresponding height
        [row_H,~] = find(top1_face_info(:,7) >= H);
        
        % CONDITION-3:find corresponding score
        [row_S1,~] = find(top1_face_info(:,8) >= S(1));
        [row_S2,~] = find(top1_face_info(:,8) >= S(2));
        [row_S3,~] = find(top1_face_info(:,8) >= S(3));
        [row_S4,~] = find(top1_face_info(:,8) >= S(4));
        
        % intersection of each condition
        common_1 = intersect(row_H,row_S1,'rows');
        common_2 = intersect(row_H,row_S2,'rows');
        common_3 = intersect(row_H,row_S3,'rows');
        common_4 = intersect(row_H,row_S4,'rows');
        
        % set 1 to the empty matrix with the condition
        condition_face_info = top1_face_info;
        % 1
        info_1 = info;
        info_1(common_1) = 1;
        condition_face_info(:,11) = info_1;
        % 2
        info_2 = info;
        info_2(common_2) = 1;
        condition_face_info(:,12) = info_2;
        % 3
        info_3 = info;
        info_3(common_3) = 1;
        condition_face_info(:,13) = info_3;
        % 4
        info_4 = info;
        info_4(common_4) = 1;
        condition_face_info(:,14) = info_4;
        
        % save results
%         file_name  = cat(2,num2str(file_content{1,2}(persons)),'-',num2str(mat_count,'%02d'),'-condition_face','.mat');        
%         person = person_matrix{person_count};
%         save_path = cat(2,person,file_name);
        file_name  = cat(2,num2str(mat_count,'%02d'),'-condition_face','.mat');
        save_path = cat(2,dst_path,file_name);
        save(save_path,'condition_face_info');
        
        % clear variables
%         clear common_1;
%         clear common_2;
%         clear common_3;
%         clear common_4;
%         
%         clear info_1;
%         clear info_2;
%         clear info_3;
%         clear info_4;
%         
%         clear row_ID;
%         clear row_H;
%         clear row_S1;
%         clear row_S2;
%         clear row_S3;
%         clear row_S4;
%         
%         clear condition_face_info;
        
    end 
    
    % clear variables
    clear row;
    
end

%%
fprintf('Finished!\n');