clear;
clc;

result_dense=load('dense.mat');
result_sparse=load('sparse.mat');
Sk=load('Sk.mat');
Wt=load('Wt.mat');

saving_dense=zeros(size(result_dense.result));
saving_sparse=zeros(size(result_sparse.result));

EC_dense=zeros(size(result_dense.result));
ET_dense=zeros(size(result_dense.result));
EC_sparse=zeros(size(result_sparse.result));
ET_sparse=zeros(size(result_sparse.result));

for ii=1:size(saving_dense,1)
    for jj=1:size(saving_sparse,2)
        
        ET_miss=sum(Wt.ans*Sk.S_k(1:5*ii)*15);        
        
        saving_dense(ii,jj)=(ET_miss-result_dense.result{ii,jj}.value)/ET_miss;
        EC_dense(ii,jj)=result_dense.result{ii,jj}.sol.EC;
        ET_dense(ii,jj)=result_dense.result{ii,jj}.sol.ET;
        
        saving_sparse(ii,jj)=(ET_miss-result_sparse.result{ii,jj}.value)/ET_miss;
        EC_sparse(ii,jj)=result_sparse.result{ii,jj}.sol.EC;
        ET_sparse(ii,jj)=result_sparse.result{ii,jj}.sol.ET;
        
    end
end

figure(1);
surf(saving_dense);
figure(2);
surf(saving_sparse);
