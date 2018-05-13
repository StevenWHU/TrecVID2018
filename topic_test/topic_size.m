%
%
%
%
clc;clear all
mat_path = '/home/cj/project/tools_code/Trecvid/2018_topic/face_mat_resize/Trecvid-topic2018_resize.mat';
mat_path_2 = '/home/cj/project/tools_code/Trecvid/2018_topic/face_mat/Trecvid-topic2018.mat';
save_path = '/home/cj/project/tools_code/Trecvid/2018_topic/face_mat_resize/';
topic_info = importdata(mat_path);

len = size(topic_info,1);
for row = 3:len
    
    % img name
    name{row - 2,1} = topic_info{row,1};
    
    if isempty(topic_info{row,2}{1,1})
        continue;
    else  
        % landmakrk coordinates
        x1 = topic_info{row,2}{1,1}(1,1);
        y1 = topic_info{row,2}{1,1}(1,2);
        x2 = topic_info{row,2}{1,1}(1,3);
        y2 = topic_info{row,2}{1,1}(1,4);

        img_width{row - 2,1} = x2 - x1; % cropped image width
        img_height{row - 2,1} = y2 - y1; % cropped image height

        clear x1;
        clear y1;
        clear x2;
        clear y2;
        
    end
end

% save
results = cat(2,name,img_height,img_width);
save_dst = cat(2,save_path,'topic_size_resize.mat');
save(save_dst,'results');

fprintf('Finished!\n');