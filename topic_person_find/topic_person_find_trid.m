%
%Function: Information Integration
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
dst_path = '/home/cj/project/tools_code/Trecvid/img_check_5/';

% read file
face_info = dir(cat(2,info_path,'*mat'));
txtread = fopen(person_path,'r');
file_content = textscan(txtread,'%s%d');

% file number
mat_num = size(face_info,1);
person_num = size(file_content{1,2},1);
%%
% create person folder
for persons = 1:person_num
    persons
    folder_name = cat(2,num2str(file_content{1,2}(persons)),'_',file_content{1,1}{persons});
    folder_path =  cat(2,dst_path,folder_name,'/');
    if ~exist(folder_path)
        mkdir(folder_path);
        fprintf('creating folder:\n%s\n',folder_path);
    end
    person_matrix{persons,1} =  folder_path;
    
end
%%
% process every mat file
for mat_count = 1:mat_num
    mat_count
    % load mat file
    mat_name = face_info(mat_count).name;
    mat_path = cat(2,info_path,mat_name);
    top1_face_info = importdata(mat_path);
    
    % process every person
    for person_count = 1:person_num
        person_count
        
        % CONDITION-1:find corresponding person
        person_ID = file_content{1,2}(person_count);% get the topic person ID
        [row,~] = find(top1_face_info(:,9) == person_ID);% get the corressponding row in mat file
        
        % process every row
        ID_num = size(row,1);
        for row_count  = 1:ID_num
            row_count
            
            % get the real row in mat file 
            org_row = row(row_count);
            
            % construct image full path
            mat_num = top1_face_info(org_row,1);
            shot_num = top1_face_info(org_row,2);
            scene_num = top1_face_info(org_row,3);
            kf_num = top1_face_info(org_row,4);
            face_num = top1_face_info(org_row,5);
            % get image name
            image_name = sprintf('%d#shot%d_%d#%d_%d_%d_%d.jpg',...
                shot_num,shot_num,scene_num,shot_num,scene_num,kf_num,face_num);
            % get image parent path
            image_parent_dir = sprintf('Trecvid-face_%s',num2str(mat_num,'%02d'));
            % full original image path
            src_image_path = cat(2,src_path,image_parent_dir,'/',image_name);
            %img = imread(image_path);
            
            % construct new image full path
            similarity_score = top1_face_info(org_row,8);% get the similarity score
            new_name = cat(2,num2str(similarity_score),image_name);
            person = person_matrix{person_count};
            dst_image_path = cat(2,person,new_name);
            
            % copyfile
            copyfile(src_image_path,dst_image_path);
            
        end
        
    end
    
    % clear variables
    clear row;
    
end

%%
fprintf('Finished!\n');