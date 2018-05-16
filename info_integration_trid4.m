%
%Function: Information Integration, change the format of v3
%Author: Chai Xiaoyu
%Data: 2018/05/16
%
%
clear,clc;
%%
%
tic;
%initialization data path
%
v3_path = '/home/cj/project/tools_code/Trecvid/result_clean/';
dst_path = '/home/cj/project/tools_code/Trecvid/result_clean_v4/';

% load file
org_files = dir(cat(2,v3_path,'*.mat'));
file_num = size(org_files,1);

for count = 1:file_num
    count
    % load file
    name =  org_files(count).name;
    file_path = cat(2,v3_path,name);
    file = importdata(file_path);
    row_num = size(file,1);
    
    % initialize a zero result matrix
    results = zeros(row_num,10);
    
    % processing file for every row
    for row = 1:row_num
        row
        % column 1
        col_1 = file{row,1};
        % find string, 1:_, 2:/, 3:#, 4:.
        index_1 = strfind(col_1,'_');
        index_2 = strfind(col_1,'/');
        index_3 = strfind(col_1,'#');
        index_4 = strfind(col_1,'.');
        new_col_1 = col_1(index_1(1) + 1:index_2(1) - 1);% new column 1
        new_col_2 = col_1(index_3(2) + 1:index_1(3) - 1);% new column 2
        new_col_3 = col_1(index_1(3) + 1:index_1(4) - 1);% new column 3
        new_col_4 = col_1(index_1(4) + 1:index_1(5) - 1);% new column 4
        new_col_5 = col_1(index_1(5) + 1:index_4(1) - 1);% new column 5
        
        % column 2~4
        new_col_6 = file{row,2};% new column 6
        new_col_7 = file{row,3};% new column 7
        new_col_8 = file{row,4};% new column 8
        
        % colume 5~6
        col_6 = file{row,6};
        index_5 = strfind(col_6,'_');
        new_col_9 = col_6(1:index_5(1) -1);
        new_col_10 = col_6(index_5(1) + 1:index_5(2) -1);
        
        % save information in reslut matrix in double format
        results(row,1) = str2double(new_col_1);% class(results(row,1))
        results(row,2) = str2double(new_col_2);% class(results(row,2))
        results(row,3) = str2double(new_col_3);% class(results(row,3))
        results(row,4) = str2double(new_col_4);% class(results(row,4))
        results(row,5) = str2double(new_col_5);% class(results(row,5))
        results(row,6) = new_col_6;% class(results(row,6))
        results(row,7) = new_col_7;% class(results(row,7))
        results(row,8) = new_col_8;% class(results(row,8))
        results(row,9) = str2double(new_col_9);% class(results(row,9))
        results(row,10) = str2double(new_col_10);% class(results(row,10))
        
    end
    % save results
    file_name = cat(2,'top1_face_info-',num2str(count,'%02d'),'.mat');
    save_path = cat(2,dst_path,file_name);
    save(save_path,'results');
    
    % clear variables
    clear results;
    
    clear new_col_1;
    clear new_col_2;
    clear new_col_3;
    clear new_col_4;
    clear new_col_5;
    clear new_col_6;
    clear new_col_7;
    clear new_col_8;
    clear new_col_9;
    clear new_col_10;
    
    clear col_1;
    clear col_6;
    
end
timespan = toc;
frintf('Finished!\n');
ftrintf('Time Cost: %f.\n',timespan);