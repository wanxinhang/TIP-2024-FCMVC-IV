function [Z] = each_iter(X,M1,M2,num_cluster,last_Z)
%ITER 此处显示有关此函数的摘要
%   此处显示详细说明
% m=lamda;
maxIter = 100;
W=eye(num_cluster);
num_dimension=size(X,1);
H=zeros(num_dimension,num_cluster);
all_samp_num=size(M1,1);%所有样本数
current_view_samp_num=size(M1,2);%当前视图样本数
last_all_num=size(M2,2);%上一轮总样本数
Z=zeros(num_cluster,all_samp_num);
%初始化H
if size(X,1)>=num_cluster
    for i=1:num_cluster
        H(i,i)=1;
    end
else
    for i=1:size(X,1)
        H(i,i)=1;
    end
end
flag = 1;
iter = 0;
while flag
    iter=iter+1;
    %update_Z
%     M1*X'
    [U,~,V] = svd(M1*X'*H+M2*last_Z'*W','econ');
    Z=U*V';
    clear U V
    Z=Z';
    
    %update_W
    [U,~,V] = svd(Z*M2*last_Z','econ');
    W=U*V';
    clear U V
    
    %update_H
    [U,~,V] = svd(X*M1'*Z','econ');
    H=U*V';
    clear U V
    
%     1/2*sum(sum((X-H*Z*M1).^2))-trace((Z*M2)'*W*last_Z)
    obj(iter) = 1/2*sum(sum((X-H*Z*M1).^2))-trace((Z*M2)'*W*last_Z);
    if (iter>2) && (abs((obj(iter)-obj(iter-1))/(obj(iter)))<1e-5 || iter>maxIter)
        flag =0;
    end
end

end
