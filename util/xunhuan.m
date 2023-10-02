function [Z] = xunhuan(fea, num_cluster,S)
%XUNHUAN 此处显示有关此函数的摘要
%   此处显示详细说明
num_view = length(fea);
time=0;
num_sample = size(fea{1},2);
rest=cell(num_view,1);
the_rest=cell(num_view,1);
all=1:num_sample;
for p =1:num_view
    if p==1
        rest{p}=all(~ismember(all,S{p}));%集合相减，获得未缺失样本集
        the_rest{p}=rest{p};
        X=fea{p}(:,the_rest{p});
        Z=initialize_Z(X,num_cluster);
%         size(Z);
%         error("暂停")
    else
        rest{p}=all(~ismember(all,S{p}));
        the_rest{p}=union(rest{p},the_rest{p-1});
        nv_t=size(the_rest{p},2);%一共有多少没缺失
        nv_t_=size(the_rest{p-1},2);%上一轮有多少没缺失
        nv_s=size(rest{p},2);%当前视图有多少没损失
        tmp=zeros(num_sample,num_sample);
        for i=1:nv_s
            tmp(rest{p}(i),rest{p}(i))=1;
        end
        M1=tmp(the_rest{p},rest{p});
        tmp=zeros(num_sample,num_sample);
        for i=1:nv_t_
            tmp(the_rest{p-1}(i),the_rest{p-1}(i))=1;
        end     
        M2=tmp(the_rest{p},the_rest{p-1});
        X=fea{p}(:,rest{p});
        Z=each_iter(X,M1,M2,num_cluster,Z);
    end

end

end

