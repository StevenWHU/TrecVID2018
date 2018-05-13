% 
% Function: reference_extract_deep_feture
% Author: Chai Xiaoyu
% Date: 2018/3/27
%
clear,clc;

%%
% load the caffe model
cur_path = '/home/cj/project/20170802_CenterFace/caffe-face/';
addpath([cur_path 'matlab']);

caffe.reset_all();
caffe.set_device(0);
caffe.set_mode_gpu();

model = './face_deploy.prototxt';
weights = './face_snapshot_20/face_train_val_iter_18000.caffemodel';
net = caffe.Net(model, weights, 'test');

%%
%initialize the parameters
Data_dir = '/home/cj/project/tools_code/Trecvid/trecvid_example/face_mat/';%.mat file
mat_dir = dir(Data_dir);
src_dir = '/home/cj/project/tools_code/Trecvid/trecvid_example/crop_topic_improve/';%image file
dst_dir = '/home/cj/project/tools_code/Trecvid/reference_feature_extracted/';%save directory

%saveing file parameters
%set the .mat file size & saving step size
file_len = 100000;%a hundred thousand row in .mat file
save_len = 20000;%every ten thousand row to save in .mat file

%%
%process 1 .mat file
%for a = 3:length(mat_dir)
for a = length(mat_dir):length(mat_dir)
    %saving file index
    index = 1;
    %
    %corpped image .mat path
    mat_path = [Data_dir mat_dir(a).name];
    
    face_info = importdata(mat_path);
    file_path = face_info(:,1);
    face_boundingboxs = face_info(:,2);
    face_points = face_info(:,3);    
    %
    s = regexp(mat_path, '/', 'split');
    sub_dir_name = cell2mat(s(9));%the 9th!
    file_name = sub_dir_name(1:end-4);
    %
    ref_feature_info = cell(0);
    %
    savefile_name = [file_name '_feature.mat'];
    savePath = [dst_dir savefile_name];
    %%
    % process every row of the .mat file
    for k = 1:length(face_boundingboxs)
        %
        k
        %fprintf('processing progress: a = %d,k= %d\n', a-2,k);
        % file info parse
        img_sub_path = file_path{k,1};
        %
        % the number of detected face
        facial5points = face_points{k, 1};
        %facial5point = cell2mat(facial5points);
        num_detect = size(facial5points,2);
        %
        % save the first colume of the .mat file of ref_feature_info
        if mod(k,file_len + 1) == 0
            ref_feature_info{k - index*file_len,1} = file_path{k,1};
        else
            ref_feature_info{k,1} = file_path{k,1};
        end
        %
        if num_detect == 0
            face_file_names = cell(0);
            features = [];
        else          
            %%
            % process every detected face
            features = [];
            face_file_names = cell(0);
            for i =1:num_detect
                %
                % generate cropped path
                face_name = img_sub_path(1:end-4);
                name = num2str(i);
                face_det_name = ['topic_improve#' face_name '_' name '.jpg'];
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
                 features(i,:) = [feature_origin feature_reversed];
                %
                % ATTENTION: the code below is simulation for image extracted features,
                % just for debug,removed when running this program!!!
                %
                %features(i,:) = mat2cell(rand(1,1024),1,1024);

                face_file_names{i,1} = face_det_name;

            end
            
        end   
        %     
        % save the second & third colume of the .mat file
        if mod(k,file_len + 1) == 0
            ref_feature_info{k - index*file_len,2} = face_file_names;
            ref_feature_info{k - index*file_len,3} = features;
        else
            ref_feature_info{k,2} = face_file_names;
            ref_feature_info{k,3} = features;
        end

        %%
        % save data in the same .mat file
        if mod(k,save_len) == 0
            savefile_name = [file_name '-feature_' num2str(index,'%02d') '.mat'];
            savePath = [dst_dir '/' savefile_name];
            save(savePath,'ref_feature_info');           
        end
        %
        % save data in the new .mat file
        if mod(k,file_len + 1) ==0
            %
            %add the subscript
            index = index + 1;
            %
            %erase all the data in .mat
            ref_feature_info = cell(0);
        end
              
    end
    %%
    index = index;
    savefile_name = [file_name '-feature_' num2str(index,'%02d') '.mat'];
    savePath = [dst_dir '/' savefile_name];
    save(savePath,'ref_feature_info');
    
end
%%
caffe.reset_all();