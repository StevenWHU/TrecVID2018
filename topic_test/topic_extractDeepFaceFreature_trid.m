%
% File Name: batch_extractDeepFeature_trid
% Function: batch_extract_deep_feture
% Author: Chai Xiaoyu
% Date: 2018/3/20
%
clear,clc;
%%
% load the caffe model

% % mat_coling add 20170802
cur_path = '/home/cj/project/20170802_CenterFace/caffe-face/';
addpath([cur_path 'matlab']);
% % addpath('path_to_matCaffe/matlab');
caffe.reset_all();
% 
% % load face model and creat networmat_col
caffe.set_device(0);
caffe.set_mode_gpu();
% % model = 'path_to_deploy/face_deploy.prototxt';
% % weights = 'path_to_model/face_model.caffemodel';
% % mat_coling M 20170802
model = './face_deploy.prototxt';
% %weights = './face_model.caffemodel';
% %weights = './face_snapshot_40/face_train_test_iter_48000.caffemodel';
weights = './face_snapshot_20/face_train_val_iter_18000.caffemodel';
% %
net = caffe.Net(model, weights, 'test');

%%
%initialize the parameters
Data_dir = '/home/cj/project/tools_code/Trecvid/2018_topic/face_mat/';
mat_dir = dir(Data_dir);
src_dir = '/home/cj/project/tools_code/Trecvid/2018_topic/crop_2018topic/';
dst_dir = '/home/cj/project/tools_code/Trecvid/topic_extracted/';%destination directory
%
%set the .mat file size & saving step size
file_len = 100000;%file_count hundred thousand row in .mat file
save_len = 20000;%every ten thousand row to save in .mat file

%%
%process 20 .mat file
for file_count = 3:length(mat_dir)
    %%
    % reset file index
    index = 1;
    % corpped image .mat path
    mat_path = [Data_dir mat_dir(file_count).name];
    face_info = importdata(mat_path);
    
    file_path = face_info(:,1);
    face_boundingboxs = face_info(:,2);
    face_points = face_info(:,3);    
    %
    s = regexp(mat_path, '/', 'split');
    sub_dir_name = cell2mat(s(8));
    file_name = sub_dir_name(1:end-4);
    %
    feature_info = cell(0);
    %
    feature_info_row = 1;
    %
    savefile_name = [file_name '_feature.mat'];
    savePath = [dst_dir savefile_name];
    
    %%
    % process every row of the .mat file
    for mat_col = 1:length(face_info)
        %%
        mat_col
        %% file info parse
        img_sub_path = file_path{mat_col,1};
        % save the first column of the .mat file of feature_info
        feature_info{feature_info_row,1} = file_path{mat_col};

        %%
        % the number of detected face
        facial5points = face_points{mat_col, 1};
        facial5point = cell2mat(facial5points);
        num_detect = size(facial5point,1);
        %%
        if num_detect == 0
            face_file_names = cell(0);
            features = [];
        else          
            %%
            % process every detected face
            face_file_names = cell(0);
            features = [];
            %
            for face_num =1:num_detect
                %
                % generate cropped path
                face_name_ = regexp(img_sub_path, '/' ,'split');
                face_name_dir = char(face_name_(1));
                face_name_shot = char(face_name_(2));
                face_name_new = cell2mat(face_name_(3));
                image_det_name = face_name_new(1:end-4);
                name = num2str(face_num);
                face_det_name = [file_name '/' face_name_dir '#' face_name_shot '#' image_det_name '_' name '.jpg'];
                crop_path = [src_dir face_det_name];
                %
                % read images
                img_origin = imread(crop_path);
                %
                % image reshape & reverse
                cropImg = single(img_origin);
                cropImg = (cropImg - 127.5)/128;
                cropImg = permute(cropImg, [2,1,3]);
                cropImg = cropImg(:,:,[3,2,1]);

                cropImg_(:,:,1) = flipud(cropImg(:,:,1));
                cropImg_(:,:,2) = flipud(cropImg(:,:,2));
                cropImg_(:,:,3) = flipud(cropImg(:,:,3));
                %
                % extract deep feature
                feature_origin = net.forward({cropImg});
                feature_reversed = net.forward({cropImg_});
                feature_origin = cell2mat(feature_origin)';
                feature_reversed = cell2mat(feature_reversed)';
                features = [feature_origin feature_reversed];
                %
                % ATTENTION: the code below is simulation for image extracted features,
                % just for debug,removed when running this program!!!
                %
                %features(face_num,:) = mat2cell(rand(1,1024),1,1024);
                %
                %face_file_names{face_num,1} = face_det_name;
                feature_info{feature_info_row,2}{face_num,1} = face_det_name;
                feature_info{feature_info_row,3}{face_num,1} = features;
                
            end
            
        end   

        %%
        % save data in the same .mat file
        if mod(feature_info_row,save_len) == 0
            savefile_name = [file_name '-feature_' num2str(index,'%02d') '.mat'];
            savePath = [dst_dir savefile_name];
            save(savePath,'feature_info');           
        end
        %
        % save data in the new .mat file
        if mod(feature_info_row,file_len) == 0
            savefile_name = [file_name '-feature_' num2str(index,'%02d') '.mat'];
            savePath = [dst_dir savefile_name];
            save(savePath,'feature_info');  
            %
            %add the subscript
            index = index + 1;
            %
            %erase all the data in .mat
            feature_info = cell(0);
            feature_info_row = 0;
        end
        feature_info_row = feature_info_row + 1;
        
    end
    %%
    if isempty(feature_info)
        continue;
    end
    savefile_name = [file_name '-feature_' num2str(index,'%02d') '.mat'];
    savePath = [dst_dir savefile_name];
    save(savePath,'feature_info');
    
end
%%
caffe.reset_all();