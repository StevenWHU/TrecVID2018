%
%Function: similarity comparison
%Author: Chai Xiaoyu
%Data: 2018/03/28
%
%
clear,clc;
%%
%initialization data path
org_img_featrue = '/home/cj/project/tools_code/Trecvid/feature_extracted_2/';
ref_img_featrue = '/home/cj/project/tools_code/Trecvid/reference_feature_extracted/';
sim_score_path = '/home/cj/project/tools_code/Trecvid/similarity_score_2/';
%file name
mat_name = 'similarity';
save_name_main = 'order_score';
%
top_num = 10;
%
save_index = 1;
%
save_len = 10000;%20000;
%
save_file = 100000;
%
rank_score_info_row = 1;
rank_score_info = cell(0);

%%
% load file
% 1-reference iamge feature
reference_path = [ref_img_featrue 'Trecvid-topicface_improve_3-feature_01.mat'];
ref_features = importdata(reference_path);
ref_len = length(ref_features);
%
% 2-origin image feature
org_img_featrue_path = dir(org_img_featrue);

%% org_num
for org_num = 3:length(org_img_featrue_path)
    org_num
    file_path = [org_img_featrue org_img_featrue_path(org_num).name];
    org_features = importdata(file_path);
    %
    keyframe_path = org_features(:,1);
    face_img_path = org_features(:,2);
    face_feature = org_features(:,3);

    %% mat_row_num, every row of the org .mat file
    for mat_row_num = 1:length(org_features)
        mat_row_num
        % add the original keyframe path to rank_score_info in colume 1
        rank_score_info{rank_score_info_row,1} = keyframe_path{mat_row_num}; 
        %
        face_num = 0;%reset face number in the original keyframe
        [face_num,~] = size(face_img_path{mat_row_num});
        %%
        if face_num ==0
            % add the data(empty cell) to rank_score_info in colume 2 & 3             
            rank_score_info{rank_score_info_row,2} = cell(0);
            rank_score_info{rank_score_info_row,3} = cell(0);
            
        else
            %% org_count, every face_image in mat_row_num
            for org_count = 1:face_num
                org_feature = cell2mat(face_feature{mat_row_num}(org_count,:));     
                scores = zeros(ref_len,1);%column vector
                
                %% ref_count
                for ref_count = 1:ref_len
                %parfor ref_count = 1:2241%ref_len
                    ref_feature = cell2mat(ref_features(ref_count,3));  
                    score = compute_cosine_score(org_feature',ref_feature');
                    scores(ref_count,1) = score;
                    
                end
                %
                [scores_order, index] = sort(scores,'descend');
                %%
                % add the data to rank_score_info                   
                % column2,original face path
                rank_score_info{rank_score_info_row,2}{org_count,1} = ...
                    face_img_path{mat_row_num}(org_count);
                
                % TOP10 results
                for matched_face_num = 1:top_num
                    %
                    ID_num = index(matched_face_num);
                    s = scores_order(matched_face_num);

                    % column3, 1~10 row, ID or path
                    rank_score_info{rank_score_info_row,3}{org_count,1}(matched_face_num,1) = ...
                        ref_features(ID_num, 2);
                    % column3, 1~10 row, score
                    rank_score_info{rank_score_info_row,3}{org_count,1}(matched_face_num,2) = ...
                        num2cell(scores_order(matched_face_num));
                end
              
            end

        end
        
        %% save results
        % save result in one .mat,10000 row
        if mod(rank_score_info_row, save_len) == 0
            save_name = ['rank_score-' num2str(save_index,'%04d') '.mat'];
            path = [sim_score_path save_name];
            save(path,'rank_score_info');

        end 

        % save result in new .mat,100000 row
        if mod(rank_score_info_row, save_file) == 0
%             save_name = ['rank_score-' num2str(save_index,'%04d') '.mat'];
%             path = [sim_score_path save_name];
%             save(path,'rank_score_info');
            %
            save_index = save_index + 1;
            % reset to zero
            rank_score_info = cell(0);
            rank_score_info_row = 0;
        end

        rank_score_info_row = rank_score_info_row + 1; 
        
    end
    
end

save_name = ['rank_score-' num2str(save_index,'%04d') '.mat'];
path = [sim_score_path '/' save_name];
save(path,'rank_score_info');
%%
fprintf('Over!\n');