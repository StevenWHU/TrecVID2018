%
%Function: similarity comparison
%Author: Chai Xiaoyu
%Data: 2018/03/28
%
%
clear,clc;
%%
% initialization data path
topic_img_featrue = '/home/cj/project/tools_code/Trecvid/topic_extracted/topic_img_features.mat';
ref_img_featrue = '/home/cj/project/tools_code/Trecvid/reference_feature_extracted/Trecvid-topicface_improve_3-feature_01.mat';
dst_path = '/home/cj/project/tools_code/Trecvid/topic_similarity_score/';

top_num = 10;

topic_rank_score_row = 1;
topic_rank_score = cell(0);

% load MAT file 
topic_img = importdata(topic_img_featrue);
ref_img = importdata(ref_img_featrue);

topic_img_num = size(topic_img,1);
ref_img_num = size(ref_img,1);

%% topic images
for topic_count = 1:topic_img_num
    topic_count
    
    % topic image name
    topic_image_name = topic_img{topic_count,1};
    % topic image feature
    topic_feature = topic_img{topic_count,2};
    
    %% reference iamges
    for ref_count = 1:ref_img_num
        ref_count
        
        % topic image feature
        ref_feature = ref_img{ref_count,3};
        score = compute_cosine_score(topic_feature',ref_feature');
        scores(ref_count,1) = score;
        
    end
    %
    [scores_order, index] = sort(scores,'descend');
    
    % TOP10 results
    for matched_face_num = 1:top_num
        %
        ID_num = index(matched_face_num);
        ref_ID = ref_img{ID_num,2};
        s = scores_order(matched_face_num);
        
        % save reault
        results{matched_face_num,1} = ref_ID;
        results{matched_face_num,2} = s;
        
    end
    
    % TOP1 ID in reference
    img_name = ref_img{index(1),1};
    str_index = strfind(img_name,'_');
    ID = img_name(1:str_index - 1);
    
    % TOP1 score in reference
    max_score = scores_order(1);
    
    % keep results
    topic_rank_score{topic_count,1} = topic_image_name;
    topic_rank_score{topic_count,2} = results;
    topic_rank_score{topic_count,3} = ID;
    topic_rank_score{topic_count,4} = max_score;
    % clear the variables
    clear results;
    
end

save_path = cat(2,dst_path,'topic_similarity.mat');
save(save_path,'topic_rank_score');

fprintf('Finished!\n');