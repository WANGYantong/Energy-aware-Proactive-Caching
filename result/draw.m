clear;
clc;

result_dense=load('dense.mat');
result_sparse=load('sparse.mat');
Sk=ones(40,1)*5*102.4;
Wt=2.63*10^(-8)*8*1024*1024;

saving_dense_No=zeros(size(result_dense.result));
saving_dense_All=zeros(size(result_dense.result));
saving_sparse_No=zeros(size(result_sparse.result));
saving_sparse_All=zeros(size(result_sparse.result));

EC_dense=zeros(size(result_dense.result));
ET_dense=zeros(size(result_dense.result));
EC_sparse=zeros(size(result_sparse.result));
ET_sparse=zeros(size(result_sparse.result));

ET_miss=zeros(size(saving_dense_All));  %No caching
EC_miss=((95.92+16.02)*4+6.25*10^(-12)*8*1024*1024*10*1024)*60*[1,3,5;1,3,5;1,3,5;1,3,5];

for ii=1:size(saving_dense_All,1)
    for jj=1:size(saving_sparse_All,2)
        
        ET_miss(ii,jj)=sum(Wt*Sk(1:10*ii)*15);
        EC_miss(ii,jj)=EC_miss(ii,jj)+ET_miss(ii,jj)/15;
        
        saving_dense_No(ii,jj)=(ET_miss(ii,jj)-result_dense.result{ii,jj}.value)/ET_miss(ii,jj);
        saving_dense_All(ii,jj)=(EC_miss(ii,jj)-result_dense.result{ii,jj}.value)/EC_miss(ii,jj);
        EC_dense(ii,jj)=result_dense.result{ii,jj}.sol.EC;
        ET_dense(ii,jj)=result_dense.result{ii,jj}.sol.ET;
        
        saving_sparse_No(ii,jj)=(ET_miss(ii,jj)-result_sparse.result{ii,jj}.value)/ET_miss(ii,jj);
        saving_sparse_All(ii,jj)=(EC_miss(ii,jj)-result_sparse.result{ii,jj}.value)/EC_miss(ii,jj);
        EC_sparse(ii,jj)=result_sparse.result{ii,jj}.sol.EC;
        ET_sparse(ii,jj)=result_sparse.result{ii,jj}.sol.ET;
        
    end
end

figure(1);

s=surf(saving_dense_No,'FaceAlpha',0.8,'FaceColor','interp');
s.EdgeColor='none';
colorbar;
xlabel('Length of Time-Slot (min)','FontSize',18,'FontWeight','bold');
ylabel('Number of Requests','FontSize',18,'FontWeight','bold');
zlabel('Energy Saving Ratio','FontSize',18,'FontWeight','bold');
ax = gca;
ax.XTick = 1:3;
ax.XTickLabel = {'1','3','5'};
ax.YTick = 1:4;
ax.YTickLabel = {'10','20','30','40'};

figure(2);

s=surf(saving_dense_All,'FaceAlpha',0.8,'FaceColor','interp');
s.EdgeColor='none';
colorbar;
xlabel('Length of Time-Slot (min)','FontSize',18,'FontWeight','bold');
ylabel('Number of Requests','FontSize',18,'FontWeight','bold');
zlabel('Energy Saving Ratio','FontSize',18,'FontWeight','bold');
ax = gca;
ax.XTick = 1:3;
ax.XTickLabel = {'1','3','5'};
ax.YTick = 1:4;
ax.YTickLabel = {'10','20','30','40'};

figure(3);
time_slot=[1,3,5];
dense_combined=zeros(size(saving_dense_All,1),2,size(saving_dense_All,2));
for ii=1:size(dense_combined,3)
    dense_combined(:,:,ii)=[EC_dense(:,ii),ET_dense(:,ii)];
    ax=subplot(1,3,ii);
    bar3(dense_combined(:,:,ii),'stacked');
    ylabel('Number of Requests','FontWeight','bold');
    zlabel('Energy Comsumption (joule)','FontWeight','bold');
    ax.YTick=1:4;
    ax.YTickLabel={'10','20','30','40'};
    title(sprintf('Time-Slot=%d min',time_slot(ii)));
end
legend('Energy for Caching','Energy for Transport');

flow_plot=1:4;
for ii=1:length(time_slot)
    figure(ii+3);
    hold on;
    plot(flow_plot,ET_miss(:,ii),'-p','Color',[0.85,0.33,0.10],'LineWidth',1.6);
    plot(flow_plot,EC_miss(:,ii),'-+','Color',[0.30,0.75,0.93],'LineWidth',1.6);
    plot(flow_plot,EC_dense(:,ii)+ET_dense(:,ii),'-*','Color',[0.64,0.08,0.18],'LineWidth',1.6);
    xlabel('Number of Requests','FontSize',18,'FontWeight','bold');
    ylabel('Energy cost (joule)','FontSize',18,'FontWeight','bold');
    lgd=legend({'No Caching','All Caching','Proposed'},'Location','north');
    lgd.FontSize=12;
    hold off;
    ax = gca;
    ax.XTick = 1:4;
    ax.XTickLabel = {'10','20','30','40'};
    title(sprintf('Time-Slot=%d min',time_slot(ii)));
end
