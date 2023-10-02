 clear all;
clc
warning off;
addpath(genpath('ClusteringMeasure'));
addpath(genpath('utils'));
addpath(genpath('measure'));
ResSavePath = 'Res/';
MaxResSavePath = 'final_res/';


if(~exist(ResSavePath,'file'))
    mkdir(ResSavePath);
    addpath(genpath(ResSavePath));
end

if(~exist(MaxResSavePath,'file'))
    mkdir(MaxResSavePath);
    addpath(genpath(MaxResSavePath));
end

dataPath = './datasets/';
% datasetName = {'Flower17','AwA_fea','MNIST_fea','Caltech256','VGGFace2_200_4Views','TinyImageNet_4Views','YouTubeFace50_4Views'};
% datasetName = {'3sources','Yale','Texas','Cornell','WebKB_cor2views','MSRCV1','Washington','WebKB_Wisconsin2views','Wisconsin','Dermatology','ORLRnSp','ORL_3Views','ORL_4Views','NGs','BBCSport','Movies','BBC','proteinFold','WebKB','HW_2Views','MFeat_2Views','uci-digit','Cora','Wiki_fea','CiteSeer','NUS-WIDE-SCENE','NUS-WIDE-OBJECT-10','Reuters-7200','Hdigit','SUNRGBD','STL10_4Views','Reuters','NUS-WIDE-OBJECT','YouTubeFace10_4Views','CIFAR100_Train_4Views','FashionMNIST_4Views','MNIST_ALL_4Views','TinyImageNet_4Views','YouTubeFace50_4Views'};
% datasetName = {'yale','Dermatology','ORL_3Views','proteinFold','Reuters','YouTubeFace10_4Views'};
% datasetName = {'WebKB_cor2views','WebKB_Wisconsin2views','Wiki_fea'};
% datasetName = {'Caltech256','VGGFace2_100_4Views','YouTubeFace20_4Views','VGGFace2_200_4Views','TinyImageNet_4Views'};
datasetName = {'MFeat_2Views','uci-digit','Wiki_fea','YouTubeFace20_4Views','VGGFace2_200_4Views','TinyImageNet_4Views'};
for dataIndex = 1 : length(datasetName)
    dataName = [dataPath datasetName{dataIndex} '.mat'];
    load(['F:\wxh_work\datasets\MultiView_Dataset\',datasetName{dataIndex} ]);
    gt=Y;
    num_cluster = max(gt);
    num_view = length(X);
    fea=cell(num_view,1);
    for v=1:num_view
        fea{v}=X{v};
    end
    clear X
    num_cluster = max(gt);
    num_view = length(fea);
    for v=1:num_view
        fea{v} = zscore(fea{v})';
    end
    for miss_per=0.1:0.1:0.5
        total_time=0;
        for iter=1:10
            ResBest = zeros(1, 8);
            ResStd = zeros(1, 8);
            % parameters setting
            r1 = 10.^(1:1:1);
            acc = zeros(length(r1), 1);
            nmi = zeros(length(r1), 1);
            purity = zeros(length(r1), 1);
            idx = 1;
            for r1Index = 1 : length(r1)
                r1Temp = r1(r1Index);
                fprintf('Please wait a few minutes\n');
                disp(['Dataset: ', datasetName{dataIndex}, ...
                    ', --r1--: ', num2str(r1Temp)]);
                resFile2 = ['F:\wxh_work\datasets\incomplete\',datasetName{dataIndex}, '_missingRatio_', num2str(miss_per),'missingIndex_iter_',num2str(iter), '.mat'];
                load(resFile2,'S');
                tic;
                [Z] = xunhuan(fea, num_cluster,S);
                time=toc;
                total_time=total_time+time;
                Z=Z';
                Z_normalized = Z ./ sqrt(sum(Z .^ 2, 2));
                res = myNMIACCwithmean(Z_normalized,Y,num_cluster);
                if iter==1
                    avg_res=res;
                else
                    avg_res=avg_res+res;
                end
            end
        end
        avg_res=avg_res/10;
        total_time=total_time/10;
        resFile3 = ['F:\wxh_work\tnnls\organ_on_H_incomplete\proposed\final_res\',datasetName{dataIndex}, '_missingRatio_', num2str(miss_per),'-ACC=', num2str(avg_res(1)), '.mat'];
        save(resFile3,'avg_res','total_time');
        resFile3 = ['F:\wxh_work\tnnls\organ_on_H_incomplete\proposed\final_res\',datasetName{dataIndex}, '_missingRatio_', num2str(miss_per), '.mat'];
        save(resFile3,'avg_res','total_time');
    end
end