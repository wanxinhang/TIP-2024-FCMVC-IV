function [Z] = initialize_Z(X,num_cluster)
%INITIALIZE_Z 此处显示有关此函数的摘要
%   此处显示详细说明
num_dimension=size(X,1);
H=zeros(num_dimension,num_cluster);
if size(X,1)>=num_cluster
    for i=1:num_cluster
        H(i,i)=1;
    end
else
    for i=1:size(X,1)
        H(i,i)=1;
    end
end
[U,~,V] = svd(X'*H,'econ');
Z=U*V';
Z=Z';
end

