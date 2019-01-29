clear;
clc;

result_dense=load('dense.mat');
result_sparse=load('sparse.mat');
Sk=load('Sk.mat');
Wt=2.63*10^(-8)*8*1024*1024;

saving_dense=zeros(size(result_dense.result));
saving_sparse=zeros(size(result_sparse.result));

EC_dense=zeros(size(result_dense.result));
ET_dense=zeros(size(result_dense.result));
EC_sparse=zeros(size(result_sparse.result));
ET_sparse=zeros(size(result_sparse.result));

ET_miss=zeros(size(saving_dense,1),1);

for ii=1:size(saving_dense,1)
    for jj=1:size(saving_sparse,2)
        
        ET_miss(ii)=sum(Wt*Sk.Sk(1:5*ii)*15);        
        
        saving_dense(ii,jj)=(ET_miss(ii)-result_dense.result{ii,jj}.value)/ET_miss(ii);
        EC_dense(ii,jj)=result_dense.result{ii,jj}.sol.EC;
        ET_dense(ii,jj)=result_dense.result{ii,jj}.sol.ET;
        
        saving_sparse(ii,jj)=(ET_miss(ii)-result_sparse.result{ii,jj}.value)/ET_miss(ii);
        EC_sparse(ii,jj)=result_sparse.result{ii,jj}.sol.EC;
        ET_sparse(ii,jj)=result_sparse.result{ii,jj}.sol.ET;
        
    end
end

figure(1);

subplot(2,1,1);
surf(saving_dense);
title('Total Energy Saving Ratio');

subplot(2,1,2);

data1=EC_dense;
data2=ET_dense;
bh=bar3(data1);
for i=1:length(bh)
      zz = get(bh(i),'Zdata');
      k = 1;
      for j = 0:6:(6*length(bh)-6)  
             zz(j+1:j+6,:)=zz(j+1:j+6,:)+data2(k,i);
             k=k+1;
      end
      set(bh(i),'Zdata',zz);
end
set(bh,'FaceColor',[1 0 0]);
hold on;
bh=bar3(data2);
set(bh,'FaceColor',[0 0 1]);
hold off;


figure(2);
surf(saving_sparse);
