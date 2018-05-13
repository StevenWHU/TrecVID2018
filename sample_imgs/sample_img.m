%
%Function: similarity comparison
%Author: Chai Xiaoyu
%Data: 2018/05/11
%
%
clear,clc;
%%
% initialization data path
img_root = '/home/cj/project/tools_code/Trecvid/img_check_3/80_90/';
dst_root = '/home/cj/project/tools_code/Trecvid/img_check_4/80_90/';
img_subdir = dir(img_root);

len = size(img_subdir,1);

% similarity score
ss_1 = 0.65;
ss_2 = 0.60;
ss_3 = 0.55;

% select number
num_1 = 15;
num_2 = 15;
num_3 = 15;
num_4 = 5;

%% Processing every sub-folder

for i = 3:len
    
    % get the ID (folder)
    ID = img_subdir(i).name;
    %
    subdirpath = cat(2, img_root,ID,'/','*.jpg');
    images = dir(subdirpath);
    names = struct2cell(images)';
    img_cell = names(:,1);
    img_num = length(img_cell);
    
    % creating a score matrix
    for n = 1:img_num
        n
        img_name = img_cell{n,1};
        score_index = strsplit(img_name,'#');
        score = cell2mat(score_index(1));
        scores(n,1) = str2num(score);
        
    end
    
    %% 1-for similarity socre lager than 0.65
    [subscores_1,~] = find(scores > ss_1);
    count_1 = length(subscores_1);
    if count_1 == 0
        % no operation
    else
        if count_1 > 0 && count_1 < num_1 % 0< count_1 <15
            
            % select all images in the scores
            for interval_1 =1:count_1
                new_scores_1(interval_1,1) =  subscores_1(interval_1);
                sub_img_name{interval_1,1} = img_cell{new_scores_1(interval_1,1),1};
                
            end
            
        else % count_1 >= 15
            
            % generate random row
            row_1 = randi([1, count_1],num_1,1);
            
            % select 15 images in the scores
            for interval_1 =1:num_1
                new_scores_1(interval_1,1) =  subscores_1(row_1(interval_1,1));
                sub_img_name{interval_1,1} = img_cell{new_scores_1(interval_1,1),1};
                
            end
            
        end
        
        % generate the full path and creating folder
        dst_path = cat(2,dst_root,ID,'/',num2str(ss_1),'/');
        if ~exist(dst_path)
            mkdir(dst_path);
            fprintf('creating file:%s\n',dst_path);
        end
        
        % copy images to the destination folder
        for img_1 = 1:size(sub_img_name,1)
            img_path = cat(2,img_root,ID,'/',sub_img_name{img_1,1});
            dst_file = cat(2,dst_path,sub_img_name{img_1,1});
            copyfile(img_path,dst_path);
            
        end
        
    end
    
    % clear variables
    clear row_1;
    clear subscores_1;
    clear interval_1;
    clear sub_img_name;
    clear new_scores_1;
    
    %% 2-for similarity socre 0.6~0.65
    [subscores_2,~] = find(scores > ss_2 & scores <= ss_1);% the range: 0.6 < score <= 0.65
    count_2 = length(subscores_2);
    if count_2 == 0
        % no operation
    else
        if count_2 > 0 && count_2 < num_2 % 0< count_2 <15
            
            % select all images in the scores
            for interval_2 =1:count_2
                new_scores_2(interval_2,1) =  subscores_2(interval_2);
                sub_img_name{interval_2,1} = img_cell{new_scores_2(interval_2,1),1};
                
            end
            
        else % count_2 >= 15
            
            % generate random row
            row_2 = randi([1, count_2],num_1,1);
            
            % select 15 images in the scores
            for interval_2 =1:num_2
                new_scores_2(interval_2,1) =  subscores_2(row_2(interval_2,1));
                sub_img_name{interval_2,1} = img_cell{new_scores_2(interval_2,1),1};
                
            end
            
        end
        
        % generate the full path and creating folder
        dst_path = cat(2,dst_root,ID,'/',num2str(ss_2),'-',num2str(ss_1),'/');
        if ~exist(dst_path)
            mkdir(dst_path);
            fprintf('creating file:%s\n',dst_path);
        end
        
        % copy images to the destination folder
        for img_2 = 1:size(sub_img_name,1)
            img_path = cat(2,img_root,ID,'/',sub_img_name{img_2,1});
            dst_file = cat(2,dst_path,sub_img_name{img_2,1});
            copyfile(img_path,dst_path);
            
        end
        
    end
    
    % clear variables
    clear row_2;
    clear subscores_2;
    clear interval_2;
    clear sub_img_name;
    clear new_scores_2;
    
    %% 3-for similarity socre lager than 0.55
    [subscores_3,~] = find(scores > ss_3 & scores <= ss_2);% the range: 0.55 < score <= 0.60
    count_3 = length(subscores_3);
    if count_3 == 0
        % no operation
    else
        if count_3 > 0 && count_3 < num_3 % 0< count_3 <15
            
            % select all images in the scores
            for interval_3 =1:count_3
                new_scores_3(interval_3,1) =  subscores_3(interval_3);
                sub_img_name{interval_3,1} = img_cell{new_scores_3(interval_3,1),1};
                
            end
            
        else % count_3 >= 15
            
            % generate random row
            row_3 = randi([1, count_3],num_1,1);
            
            % select 15 images in the scores
            for interval_3 =1:num_3
                new_scores_3(interval_3,1) =  subscores_3(row_3(interval_3,1));
                sub_img_name{interval_3,1} = img_cell{new_scores_3(interval_3,1),1};
                
            end
            
        end
        
        % generate the full path and creating folder
        dst_path = cat(2,dst_root,ID,'/',num2str(ss_3),'-',num2str(ss_2),'/');
        if ~exist(dst_path)
            mkdir(dst_path);
            fprintf('creating file:%s\n',dst_path);
        end
        
        % copy images to the destination folder
        for img_3 = 1:size(sub_img_name,1)
            img_path = cat(2,img_root,ID,'/',sub_img_name{img_3,1});
            dst_file = cat(2,dst_path,sub_img_name{img_3,1});
            copyfile(img_path,dst_path);
            
        end
        
    end
    
    % clear variables
    clear row_3;
    clear subscores_3;
    clear interval_3;
    clear sub_img_name;
    clear new_scores_3;
    
    %% 4-for similarity socre lager than 0.50
    [subscores_4,~] = find(scores <= ss_3);% the range: score <= 0.55
    count_4 = length(subscores_4);
    if count_4 == 0
        % no operation
    else
        if count_4 > 0 && count_4 < num_4 % 0< count_4 <15
            
            % select all images in the scores
            for interval_4 =1:count_4
                new_scores_4(interval_4,1) =  subscores_4(interval_4);
                sub_img_name{interval_4,1} = img_cell{new_scores_4(interval_4,1),1};
                
            end
            
        else % count_4 >= 15
            
            % generate random row
            row_4 = randi([1, count_4],num_4,1);
            
            % select 15 images in the scores
            for interval_4 =1:num_4
                new_scores_4(interval_4,1) =  subscores_4(row_4(interval_4,1));
                sub_img_name{interval_4,1} = img_cell{new_scores_4(interval_4,1),1};
                
            end
            
        end
        
        % generate the full path and creating folder
        dst_path = cat(2,dst_root,ID,'/',num2str(ss_3),'/');
        if ~exist(dst_path)
            mkdir(dst_path);
            fprintf('creating file:%s\n',dst_path);
        end
        
        % copy images to the destination folder
        for img_4 = 1:size(sub_img_name,1)
            img_path = cat(2,img_root,ID,'/',sub_img_name{img_4,1});
            dst_file = cat(2,dst_path,sub_img_name{img_4,1});
            copyfile(img_path,dst_path);
            
        end
        
    end
    
    % clear variables
    clear row_4;
    clear subscores_4;
    clear interval_4;
    clear sub_img_name;
    clear new_scores_4;
    
    %%
    % clear variables
    clear score;
    clear scores;
    
    fprintf('Identity %d has processed!\n',str2num(ID));
    
end

fprintf('Finished!\n');