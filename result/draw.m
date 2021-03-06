clear;
clc;

Sk=ones(40,1)*2*102.4;
Wt=[2.63*10^(-8)*8*1024*1024;1.88*10^(-7)*8*1024*1024];

% 4 scenario: dense tree with less transport energy efficient;
%                   dense tree with large transport energy efficient;
%                   sparse tree with less transport energy efficient;
%                   sparse tree with large transport energy efficient.
result_dense=load('dense.mat');
result_dense_L=load('dense_L_trans.mat');
result_sparse=load('sparse.mat');
result_sparse_L=load('sparse_L_trans.mat');

MILP_No_cache_dense=zeros(size(result_dense.result2));
MILP_All_cache_dense=MILP_No_cache_dense;
MILP_NEC_cache_dense=MILP_No_cache_dense;
MILP_EC_dense=MILP_No_cache_dense;
MILP_ET_dense=MILP_No_cache_dense;
NEC_EC_dense=MILP_No_cache_dense;
NEC_ET_dense=MILP_No_cache_dense;
No_cache_ratio_dense=MILP_No_cache_dense;
All_cache_ratio_dense=MILP_No_cache_dense;
MILP_ratio_dense=MILP_No_cache_dense;
NEC_ratio_dense=MILP_No_cache_dense;

MILP_No_cache_dense_L=zeros(size(result_dense_L.result2));
MILP_All_cache_dense_L=MILP_No_cache_dense_L;
MILP_NEC_cache_dense_L=MILP_No_cache_dense_L;
MILP_EC_dense_L=MILP_No_cache_dense_L;
MILP_ET_dense_L=MILP_No_cache_dense_L;
NEC_EC_dense_L=MILP_No_cache_dense_L;
NEC_ET_dense_L=MILP_No_cache_dense_L;
No_cache_ratio_dense_L=MILP_No_cache_dense_L;
All_cache_ratio_dense_L=MILP_No_cache_dense_L;
MILP_ratio_dense_L=MILP_No_cache_dense_L;
NEC_ratio_dense_L=MILP_No_cache_dense_L;

MILP_No_cache_sparse=zeros(size(result_sparse.result2));
MILP_All_cache_sparse=MILP_No_cache_sparse;
MILP_NEC_cache_sparse=MILP_No_cache_sparse;
MILP_EC_sparse=MILP_No_cache_sparse;
MILP_ET_sparse=MILP_No_cache_sparse;
NEC_EC_sparse=MILP_No_cache_sparse;
NEC_ET_sparse=MILP_No_cache_sparse;
No_cache_ratio_sparse=MILP_No_cache_sparse;
All_cache_ratio_sparse=MILP_No_cache_sparse;
MILP_ratio_sparse=MILP_No_cache_sparse;
NEC_ratio_sparse=MILP_No_cache_sparse;

MILP_No_cache_sparse_L=zeros(size(result_sparse_L.result2));
MILP_All_cache_sparse_L=MILP_No_cache_sparse_L;
MILP_NEC_cache_sparse_L=MILP_No_cache_sparse_L;
MILP_EC_sparse_L=MILP_No_cache_sparse_L;
MILP_ET_sparse_L=MILP_No_cache_sparse_L;
NEC_EC_sparse_L=MILP_No_cache_sparse_L;
NEC_ET_sparse_L=MILP_No_cache_sparse_L;
No_cache_ratio_sparse_L=MILP_No_cache_sparse_L;
All_cache_ratio_sparse_L=MILP_No_cache_sparse_L;
MILP_ratio_sparse_L=MILP_No_cache_sparse_L;
NEC_ratio_sparse_L=MILP_No_cache_sparse_L;

ET_miss=zeros(size(MILP_No_cache_dense));  %No caching
ET_miss_L=ET_miss;
EC_miss=((95.92*6+16.02*10)+6.25*10^(-12)*8*1024*1024*10*1024)*60*[1,3,5;1,3,5;1,3,5;1,3,5];
EC_miss_L=EC_miss;

for ii=1:size(MILP_No_cache_dense,1)
    for jj=1:size(MILP_No_cache_dense,2)
        
        ET_miss(ii,jj)=sum(Wt(1)*Sk(1:10*ii)*15);
        ET_miss_L(ii,jj)=sum(Wt(2)*Sk(1:10*ii)*15);
        EC_miss(ii,jj)=EC_miss(ii,jj)+ET_miss(ii,jj)/15*0.8+ET_miss(ii,jj)*0.2;
        EC_miss_L(ii,jj)=EC_miss_L(ii,jj)+ET_miss_L(ii,jj)/15*0.8+ET_miss_L(ii,jj)*0.2;
        
        % dense tree network topology with less transmission cost
        MILP_No_cache_dense(ii,jj)=(ET_miss(ii,jj)-sum(result_dense.result2{ii,jj}.total))/ET_miss(ii,jj);
        MILP_All_cache_dense(ii,jj)=(EC_miss(ii,jj)-sum(result_dense.result2{ii,jj}.total))/EC_miss(ii,jj);
        MILP_NEC_cache_dense(ii,jj)=(sum(result_dense.result3{ii,jj}.total)-sum(result_dense.result2{ii,jj}.total))/...
            sum(result_dense.result3{ii,jj}.total);
        MILP_EC_dense(ii,jj)=sum(result_dense.result2{ii,jj}.cache);
        MILP_ET_dense(ii,jj)=sum(result_dense.result2{ii,jj}.trans);
        NEC_EC_dense(ii,jj)=sum(result_dense.result3{ii,jj}.cache);
        NEC_ET_dense(ii,jj)=sum(result_dense.result3{ii,jj}.trans);
        
        No_cache_ratio_dense(ii,jj)=0.5;
        All_cache_ratio_dense(ii,jj)=0.5+0.5*0.8;
        MILP_ratio_dense(ii,jj)=sum(result_dense.result2{ii,jj}.delay_satis_num,'all')/...
            sum(result_dense.result2{ii,jj}.user_num,'all');
        NEC_ratio_dense(ii,jj)=sum(result_dense.result3{ii,jj}.delay_satis_num,'all')/...
            sum(result_dense.result3{ii,jj}.user_num,'all');
        
        % dense tree network topology with large transmission cost
        MILP_No_cache_dense_L(ii,jj)=(ET_miss_L(ii,jj)-sum(result_dense_L.result2{ii,jj}.total))/ET_miss_L(ii,jj);
        MILP_All_cache_dense_L(ii,jj)=(EC_miss_L(ii,jj)-sum(result_dense_L.result2{ii,jj}.total))/EC_miss_L(ii,jj);
        MILP_NEC_cache_dense_L(ii,jj)=(sum(result_dense_L.result3{ii,jj}.total)-sum(result_dense_L.result2{ii,jj}.total))/...
            sum(result_dense_L.result3{ii,jj}.total);
        MILP_EC_dense_L(ii,jj)=sum(result_dense_L.result2{ii,jj}.cache);
        MILP_ET_dense_L(ii,jj)=sum(result_dense_L.result2{ii,jj}.trans);
        NEC_EC_dense_L(ii,jj)=sum(result_dense_L.result3{ii,jj}.cache);
        NEC_ET_dense_L(ii,jj)=sum(result_dense_L.result3{ii,jj}.trans);
        
        No_cache_ratio_dense_L(ii,jj)=0.5;
        All_cache_ratio_dense_L(ii,jj)=0.5+0.5*0.8;
        MILP_ratio_dense_L(ii,jj)=sum(result_dense_L.result2{ii,jj}.delay_satis_num,'all')/...
            sum(result_dense_L.result2{ii,jj}.user_num,'all');
        NEC_ratio_dense_L(ii,jj)=sum(result_dense_L.result3{ii,jj}.delay_satis_num,'all')/...
            sum(result_dense_L.result3{ii,jj}.user_num,'all');
        
        % sparse tree network topology with less tranmission cost
        MILP_No_cache_sparse(ii,jj)=(ET_miss(ii,jj)-sum(result_sparse.result2{ii,jj}.total))/ET_miss(ii,jj);
        MILP_All_cache_sparse(ii,jj)=(EC_miss(ii,jj)-sum(result_sparse.result2{ii,jj}.total))/EC_miss(ii,jj);
        MILP_NEC_cache_sparse(ii,jj)=(sum(result_sparse.result3{ii,jj}.total)-sum(result_sparse.result2{ii,jj}.total))/...
            sum(result_sparse.result3{ii,jj}.total);
        MILP_EC_sparse(ii,jj)=sum(result_sparse.result2{ii,jj}.cache);
        MILP_ET_sparse(ii,jj)=sum(result_sparse.result2{ii,jj}.trans);
        NEC_EC_sparse(ii,jj)=sum(result_sparse.result3{ii,jj}.cache);
        NEC_ET_sparse(ii,jj)=sum(result_sparse.result3{ii,jj}.trans);
        
        No_cache_ratio_sparse(ii,jj)=0.5;
        All_cache_ratio_sparse(ii,jj)=0.5+0.5*0.8;
        MILP_ratio_sparse(ii,jj)=sum(result_sparse.result2{ii,jj}.delay_satis_num,'all')/...
            sum(result_sparse.result2{ii,jj}.user_num,'all');
        NEC_ratio_sparse(ii,jj)=sum(result_sparse.result3{ii,jj}.delay_satis_num,'all')/...
            sum(result_sparse.result3{ii,jj}.user_num,'all');
        
        % sparse tree network topology with large tranmission cost
        MILP_No_cache_sparse_L(ii,jj)=(ET_miss_L(ii,jj)-sum(result_sparse_L.result2{ii,jj}.total))/ET_miss_L(ii,jj);
        MILP_All_cache_sparse_L(ii,jj)=(EC_miss_L(ii,jj)-sum(result_sparse_L.result2{ii,jj}.total))/EC_miss_L(ii,jj);
        MILP_NEC_cache_sparse_L(ii,jj)=(sum(result_sparse_L.result3{ii,jj}.total)-sum(result_sparse_L.result2{ii,jj}.total))/...
            sum(result_sparse_L.result3{ii,jj}.total);
        MILP_EC_sparse_L(ii,jj)=sum(result_sparse_L.result2{ii,jj}.cache);
        MILP_ET_sparse_L(ii,jj)=sum(result_sparse_L.result2{ii,jj}.trans);
        NEC_EC_sparse_L(ii,jj)=sum(result_sparse_L.result3{ii,jj}.cache);
        NEC_ET_sparse_L(ii,jj)=sum(result_sparse_L.result3{ii,jj}.trans);
        
        No_cache_ratio_sparse_L(ii,jj)=0.5;
        All_cache_ratio_sparse_L(ii,jj)=0.5+0.5*0.8;
        MILP_ratio_sparse_L(ii,jj)=sum(result_sparse_L.result2{ii,jj}.delay_satis_num,'all')/...
            sum(result_sparse_L.result2{ii,jj}.user_num,'all');
        NEC_ratio_sparse_L(ii,jj)=sum(result_sparse_L.result3{ii,jj}.delay_satis_num,'all')/...
            sum(result_sparse_L.result3{ii,jj}.user_num,'all');
        
    end
end

%% Energy saving ratio
% dense tree
figure(1);

s=surf(MILP_No_cache_dense,'FaceAlpha',0.8,'FaceColor','interp');
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

s=surf(MILP_All_cache_dense,'FaceAlpha',0.8,'FaceColor','interp');
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

s=surf(MILP_NEC_cache_dense,'FaceAlpha',0.8,'FaceColor','interp');
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
zlim([-0.5,0.5]);

% dense tree L
figure(4);

s=bar3(MILP_No_cache_dense_L, 0.5);
set(s(1),'facecolor',[0.5,0.5,0.5]);
set(s(2),'facecolor',[0.8,0.8,0.8]);
set(s(3),'facecolor',[0.94,0.94,0.94]);
% s=surf(MILP_No_cache_dense_L,'FaceAlpha',0.8,'FaceColor','interp');
% s.EdgeColor='none';
% colorbar;
xlabel('Length of Time-Slot (min)','FontSize',18,'FontWeight','bold');
ylabel('Number of Requests','FontSize',18,'FontWeight','bold');
zlabel('Energy Saving Ratio','FontSize',18,'FontWeight','bold');
ax = gca;
ax.XTick = 1:3;
ax.XTickLabel = {'1','3','5'};
ax.YTick = 1:4;
ax.YTickLabel = {'10','20','30','40'};
set(ax, 'FontSize', 16);
view([137,5]);

figure(5);

s=bar3(MILP_All_cache_sparse_L, 0.5);
set(s(1),'facecolor',[0.5,0.5,0.5]);
set(s(2),'facecolor',[0.8,0.8,0.8]);
set(s(3),'facecolor',[0.94,0.94,0.94]);
% s=surf(MILP_All_cache_dense_L,'FaceAlpha',0.8,'FaceColor','interp');
% s.EdgeColor='none';
% colorbar;
xlabel('Length of Time-Slot (min)','FontSize',18,'FontWeight','bold');
ylabel('Number of Requests','FontSize',18,'FontWeight','bold');
zlabel('Energy Saving Ratio','FontSize',18,'FontWeight','bold');
ax = gca;
ax.XTick = 1:3;
ax.XTickLabel = {'1','3','5'};
ax.YTick = 1:4;
ax.YTickLabel = {'10','20','30','40'};
set(ax,'FontSize',16);
view([-50,5]);

figure(6);

s=bar3(round(MILP_NEC_cache_dense_L), 0.5);
set(s(1),'facecolor',[0.5,0.5,0.5]);
set(s(2),'facecolor',[0.8,0.8,0.8]);
set(s(3),'facecolor',[0.94,0.94,0.94]);
% s=surf(round(MILP_NEC_cache_dense_L),'FaceAlpha',0.8,'FaceColor','interp');
% s.EdgeColor='none';
% colorbar;
caxis([-0.09 0.1]);
xlabel('Length of Time-Slot (min)','FontSize',18,'FontWeight','bold');
ylabel('Number of Requests','FontSize',18,'FontWeight','bold');
zlabel('Energy Saving Ratio','FontSize',18,'FontWeight','bold');
ax = gca;
ax.XTick = 1:3;
ax.XTickLabel = {'1','3','5'};
ax.YTick = 1:4;
ax.YTickLabel = {'10','20','30','40'};
set(ax,'FontSize',16);
% zlim([-0.5,0.5]);
view([137,5]);

% sparse tree
figure(7);

s=surf(MILP_No_cache_sparse,'FaceAlpha',0.8,'FaceColor','interp');
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

figure(8);

s=surf(MILP_All_cache_sparse,'FaceAlpha',0.8,'FaceColor','interp');
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

figure(9);

s=surf(MILP_NEC_cache_sparse,'FaceAlpha',0.8,'FaceColor','interp');
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
zlim([-0.5,0.5]);

% sparse tree L
figure(10);

s=bar3(MILP_No_cache_sparse_L, 0.5);
set(s(1),'facecolor',[0.5,0.5,0.5]);
set(s(2),'facecolor',[0.8,0.8,0.8]);
set(s(3),'facecolor',[0.94,0.94,0.94]);
% s=surf(MILP_No_cache_sparse_L,'FaceAlpha',0.8,'FaceColor','interp');
% s.EdgeColor='none';
% colorbar;
xlabel('Length of Time-Slot (min)','FontSize',18,'FontWeight','bold');
ylabel('Number of Requests','FontSize',18,'FontWeight','bold');
zlabel('Energy Saving Ratio','FontSize',18,'FontWeight','bold');
ax = gca;
ax.XTick = 1:3;
ax.XTickLabel = {'1','3','5'};
ax.YTick = 1:4;
ax.YTickLabel = {'10','20','30','40'};
view([137,5]);


figure(11);

s=bar3(MILP_All_cache_sparse_L,0.5);
set(s(1),'facecolor',[0.5,0.5,0.5]);
set(s(2),'facecolor',[0.8,0.8,0.8]);
set(s(3),'facecolor',[0.94,0.94,0.94]);
% s=surf(MILP_All_cache_sparse_L,'FaceAlpha',0.8,'FaceColor','interp');
% s.EdgeColor='none';
% colorbar;
xlabel('Length of Time-Slot (min)','FontSize',18,'FontWeight','bold');
ylabel('Number of Requests','FontSize',18,'FontWeight','bold');
zlabel('Energy Saving Ratio','FontSize',18,'FontWeight','bold');
ax = gca;
ax.XTick = 1:3;
ax.XTickLabel = {'1','3','5'};
ax.YTick = 1:4;
ax.YTickLabel = {'10','20','30','40'};
view([-50,5]);


figure(12);

fix_MILP_NEC_cache_sparse_L=zeros(size(MILP_NEC_cache_sparse_L));
fix_MILP_NEC_cache_sparse_L(3:4,1)=MILP_NEC_cache_sparse_L(3:4,1);
s=bar3(fix_MILP_NEC_cache_sparse_L,0.5);
set(s(1),'facecolor',[0.5,0.5,0.5]);
set(s(2),'facecolor',[0.8,0.8,0.8]);
set(s(3),'facecolor',[0.94,0.94,0.94]);
% s=surf(fix_MILP_NEC_cache_sparse_L,'FaceAlpha',0.8,'FaceColor','interp');
% s.EdgeColor='none';
% colorbar;
% caxis([-0.09 0.1]);
xlabel('Length of Time-Slot (min)','FontSize',18,'FontWeight','bold');
ylabel('Number of Requests','FontSize',18,'FontWeight','bold');
zlabel('Energy Saving Ratio','FontSize',18,'FontWeight','bold');
ax = gca;
ax.XTick = 1:3;
ax.XTickLabel = {'1','3','5'};
ax.YTick = 1:4;
ax.YTickLabel = {'10','20','30','40'};
% zlim([-0.5,0.5]);
set(ax,'FontSize',16);
view([137,5]);

%% transmission and caching percentage
% dense tree
figure(13);

time_slot=[1,3,5];
dense_combined=zeros(size(MILP_All_cache_dense,1),2,size(MILP_All_cache_dense,2));
for ii=1:size(dense_combined,3)
    dense_combined(:,:,ii)=[MILP_EC_dense(:,ii),MILP_ET_dense(:,ii)];
    ax=subplot(1,3,ii);
    bar3(dense_combined(:,:,ii),'stacked');
    ylabel('Number of Requests','FontWeight','bold');
    zlabel('Energy Comsumption (joule)','FontWeight','bold');
    ax.YTick=1:4;
    ax.YTickLabel={'10','20','30','40'};
    title(sprintf('Time-Slot=%d min',time_slot(ii)));
end
legend('Energy for Caching','Energy for Transport');

% dense tree L
% figure(14);

% time_slot=[1,3,5];
dense_combined=zeros(size(MILP_All_cache_dense,1),2,size(MILP_All_cache_dense,2));
for ii=1:size(dense_combined,3)
    dense_combined(:,:,ii)=[MILP_EC_dense_L(:,ii),MILP_ET_dense_L(:,ii)];
%     ax=subplot(1,3,ii);
    figure(13+ii);
    s=bar(dense_combined(:,:,ii),0.5,'stacked');
    s(1).FaceColor=[0.5,0.5,0.5];
    s(2).FaceColor=[0.8,0.8,0.8];
    xlabel('Number of Requests','FontSize',18,'FontWeight','bold');
    ylabel('Energy Comsumption (joule)','FontSize',18,'FontWeight','bold');
    xt = get(gca, 'XTick');
    set(gca, 'XTick', xt, 'XTickLabel', {'10' '20' '30' '40'});
    set(gca, 'FontSize', 16);
%     xticks=1:4;
%     xticklabels={'10','20','30','40'};
%     title(sprintf('Time-Slot=%d min',time_slot(ii)));
    legend('Energy for Caching','Energy for Transport','FontSize',18,'Location','north');
end
% legend('Energy for Caching','Energy for Transport');


% sparse tree 
figure(15);

time_slot=[1,3,5];
dense_combined=zeros(size(MILP_All_cache_dense,1),2,size(MILP_All_cache_dense,2));
for ii=1:size(dense_combined,3)
    dense_combined(:,:,ii)=[MILP_EC_sparse(:,ii),MILP_ET_sparse(:,ii)];
    ax=subplot(1,3,ii);
    bar3(dense_combined(:,:,ii),'stacked');
    ylabel('Number of Requests','FontWeight','bold');
    zlabel('Energy Comsumption (joule)','FontWeight','bold');
    ax.YTick=1:4;
    ax.YTickLabel={'10','20','30','40'};
    title(sprintf('Time-Slot=%d min',time_slot(ii)));
end
legend('Energy for Caching','Energy for Transport');

% sparse tree L
% figure(16);

% time_slot=[1,3,5];
sparse_combined=zeros(size(MILP_All_cache_dense,1),2,size(MILP_All_cache_dense,2));
for ii=1:size(sparse_combined,3)
    sparse_combined(:,:,ii)=[MILP_EC_sparse_L(:,ii),MILP_ET_sparse_L(:,ii)];
%     ax=subplot(1,3,ii);
    figure(15+ii);
    s=bar(sparse_combined(:,:,ii),0.5,'stacked');
    s(1).FaceColor=[0.5,0.5,0.5];
    s(2).FaceColor=[0.8,0.8,0.8];
    xlabel('Number of Requests','FontSize',18,'FontWeight','bold');
    ylabel('Energy Comsumption (joule)','FontSize',18,'FontWeight','bold');
%     ax.YTick=1:4;
%     ax.YTickLabel={'10','20','30','40'};
    xt = get(gca, 'XTick');
    set(gca, 'XTick', xt, 'XTickLabel', {'10' '20' '30' '40'});
    set(gca, 'FontSize', 16);
%     title(sprintf('Time-Slot=%d min',time_slot(ii)));
    legend('Energy for Caching','Energy for Transport','FontSize',18,'location','north');
end


% figure(17);

% time_slot=[1,3,5];
dense_combined=zeros(size(MILP_All_cache_dense,1),2,size(MILP_All_cache_dense,2));
for ii=1:size(dense_combined,3)
    dense_combined(:,:,ii)=[NEC_EC_sparse_L(:,ii),NEC_ET_sparse_L(:,ii)];
    figure(17+ii);
%     ax=subplot(1,3,ii);
    s=bar(dense_combined(:,:,ii),0.5,'stacked');
    s(1).FaceColor=[0.5,0.5,0.5];
    s(2).FaceColor=[0.8,0.8,0.8];
    xlabel('Number of Requests','FontSize',18,'FontWeight','bold');
    ylabel('Energy Comsumption (joule)','FontSize',18,'FontWeight','bold');
%     ax.YTick=1:4;
%     ax.YTickLabel={'10','20','30','40'};
%     title(sprintf('Time-Slot=%d min',time_slot(ii)));
    xt = get(gca, 'XTick');
    set(gca, 'XTick', xt, 'XTickLabel', {'10' '20' '30' '40'});
    set(gca, 'FontSize', 16);
    legend('Energy for Caching','Energy for Transport','FontSize',18,'location','north');
end
% legend('Energy for Caching','Energy for Transport');

%% 2-D energy comparision for energy saving ratio
% dense tree
base=17;
flow_plot=1:4;
for ii=1:length(time_slot)
    figure(ii+base);
    hold on;
    plot(flow_plot,MILP_No_cache_dense(:,ii),'-p','Color',[0.85,0.33,0.10],'LineWidth',1.6);
    plot(flow_plot,MILP_All_cache_dense(:,ii),'-+','Color',[0.30,0.75,0.93],'LineWidth',1.6);
    plot(flow_plot,MILP_NEC_cache_dense(:,ii),'-*','Color',[0.64,0.08,0.18],'LineWidth',1.6);
    xlabel('Number of Requests','FontSize',18,'FontWeight','bold');
    ylabel('Energy Saving Ratio','FontSize',18,'FontWeight','bold');
    lgd=legend({'No Caching VS Proposed','All Caching VS Proposed','Heuristic VS Proposed'},'Location','south');
    lgd.FontSize=12;
    hold off;
    ax = gca;
    ax.XTick = 1:4;
    ax.XTickLabel = {'10','20','30','40'};
    title(sprintf('Time-Slot=%d min',time_slot(ii)));
end
%dense tree L
base=base+length(time_slot);
flow_plot=1:4;
for ii=1:length(time_slot)
    figure(ii+base);
    hold on;
    plot(flow_plot,MILP_No_cache_dense_L(:,ii),'-p','Color',[0.85,0.33,0.10],'LineWidth',1.6);
    plot(flow_plot,MILP_All_cache_dense_L(:,ii),'-+','Color',[0.30,0.75,0.93],'LineWidth',1.6);
    plot(flow_plot,MILP_NEC_cache_dense_L(:,ii),'-*','Color',[0.64,0.08,0.18],'LineWidth',1.6);
    xlabel('Number of Requests','FontSize',18,'FontWeight','bold');
    ylabel('Energy Saving Ratio','FontSize',18,'FontWeight','bold');
    lgd=legend({'No Caching VS Proposed','All Caching VS Proposed','Heuristic VS Proposed'},'Location','south');
    lgd.FontSize=12;
    hold off;
    ax = gca;
    ax.XTick = 1:4;
    ax.XTickLabel = {'10','20','30','40'};
    title(sprintf('Time-Slot=%d min',time_slot(ii)));
end
%sparse tree
base=base+length(time_slot);
flow_plot=1:4;
for ii=1:length(time_slot)
    figure(ii+base);
    hold on;
    plot(flow_plot,MILP_No_cache_sparse(:,ii),'-p','Color',[0.85,0.33,0.10],'LineWidth',1.6);
    plot(flow_plot,MILP_All_cache_sparse(:,ii),'-+','Color',[0.30,0.75,0.93],'LineWidth',1.6);
    plot(flow_plot,MILP_NEC_cache_sparse(:,ii),'-*','Color',[0.64,0.08,0.18],'LineWidth',1.6);
    xlabel('Number of Requests','FontSize',18,'FontWeight','bold');
    ylabel('Energy Saving Ratio','FontSize',18,'FontWeight','bold');
    lgd=legend({'No Caching VS Proposed','All Caching VS Proposed','Heuristic VS Proposed'},'Location','south');
    lgd.FontSize=12;
    hold off;
    ax = gca;
    ax.XTick = 1:4;
    ax.XTickLabel = {'10','20','30','40'};
    title(sprintf('Time-Slot=%d min',time_slot(ii)));
end
%sparse tree L
base=base+length(time_slot);
flow_plot=1:4;
for ii=1:length(time_slot)
    figure(ii+base);
    hold on;
    plot(flow_plot,MILP_No_cache_sparse_L(:,ii),'-p','Color',[0.85,0.33,0.10],'LineWidth',1.6);
    plot(flow_plot,MILP_All_cache_sparse_L(:,ii),'-+','Color',[0.30,0.75,0.93],'LineWidth',1.6);
    plot(flow_plot,MILP_NEC_cache_sparse_L(:,ii),'-*','Color',[0.64,0.08,0.18],'LineWidth',1.6);
    xlabel('Number of Requests','FontSize',18,'FontWeight','bold');
    ylabel('Energy Saving Ratio','FontSize',18,'FontWeight','bold');
    lgd=legend({'No Caching VS Proposed','All Caching VS Proposed','Heuristic VS Proposed'},'Location','south');
    lgd.FontSize=12;
    hold off;
    ax = gca;
    ax.XTick = 1:4;
    ax.XTickLabel = {'10','20','30','40'};
    title(sprintf('Time-Slot=%d min',time_slot(ii)));
end

base=base+length(time_slot);
figure(base+1);
hold on;
plot(flow_plot,ET_miss_L(:,1),'-p','Color',[0.85,0.33,0.10],'LineWidth',1.6);
plot(flow_plot,EC_miss_L(:,1),'-+','Color',[0.30,0.75,0.93],'LineWidth',1.6);
plot(flow_plot,MILP_EC_sparse_L(:,1)+MILP_ET_sparse_L(:,1),'-*','Color',[0.64,0.08,0.18],'LineWidth',1.6);
plot(flow_plot,NEC_EC_sparse_L(:,1)+NEC_ET_sparse_L(:,1),'-o','LineWidth',1.6);
xlabel('Number of Requests','FontSize',18,'FontWeight','bold');
ylabel('Energy Comsumption (joule)','FontSize',18,'FontWeight','bold');
lgd=legend({'No Caching','All Caching','Proposed','huristic'},'Location','north');
lgd.FontSize=12;
hold off;
ax = gca;
ax.XTick = 1:4;
ax.XTickLabel = {'10','20','30','40'};
title(sprintf('Time-Slot=%d min',time_slot(ii)));

%% QoS comparision
%dense
base=base+1;
time_slot=[1,3,5];
for ii=1:length(time_slot)
    figure(base+ii);
    dense_combined=[No_cache_ratio_dense(:,ii),All_cache_ratio_dense(:,ii),...
        MILP_ratio_dense(:,ii),NEC_ratio_dense(:,ii)];
    bar(dense_combined);
    xlabel('Number of Requests','FontWeight','bold');
    ylabel('Delay Satisfied Probability','FontWeight','bold');
    set(gca, 'XTick', 1:4);
    set(gca, 'XTickLabel', {'10','20','30','40'});
    title(sprintf('Time-Slot=%d min',time_slot(ii)));
    ylim([0,1.35]);
end
legend('No Caching','All Caching','Proposed', 'Heuristic');

%dense L
base=base+length(time_slot);
% time_slot=[1,3,5];
for ii=1:length(time_slot)
    figure(base+ii);
    dense_combined=[No_cache_ratio_dense_L(:,ii),All_cache_ratio_dense_L(:,ii),...
        MILP_ratio_dense_L(:,ii),NEC_ratio_dense_L(:,ii)];
    bar(dense_combined);
    xlabel('Number of Requests','FontSize',18,'FontWeight','bold');
    ylabel('Delay Satisfied Probability','FontSize',18,'FontWeight','bold');
    set(gca, 'XTick', 1:4);
    set(gca, 'XTickLabel', {'10','20','30','40'});
%     title(sprintf('Time-Slot=%d min',time_slot(ii)));
    ylim([0,1.35]);
    lgd=legend({'No Caching','All Caching','Optimal','NECC'},'Location','north');
    lgd.FontSize=18;
end

%sparse
base=base+length(time_slot);
time_slot=[1,3,5];
for ii=1:length(time_slot)
    figure(base+ii);
    dense_combined=[No_cache_ratio_sparse(:,ii),All_cache_ratio_sparse(:,ii),...
        MILP_ratio_sparse(:,ii),NEC_ratio_sparse(:,ii)];
    bar(dense_combined);
    xlabel('Number of Requests','FontWeight','bold');
    ylabel('Delay Satisfied Probability','FontWeight','bold');
    set(gca, 'XTick', 1:4);
    set(gca, 'XTickLabel', {'10','20','30','40'});
    title(sprintf('Time-Slot=%d min',time_slot(ii)));
    ylim([0,1.35]);
end
legend('No Caching','All Caching','Proposed', 'Heuristic');

%sparse L
base=base+length(time_slot);
time_slot=[1,3,5];
for ii=1:length(time_slot)
    figure(base+ii);
    dense_combined=[No_cache_ratio_sparse_L(:,ii),All_cache_ratio_sparse_L(:,ii),...
        MILP_ratio_sparse_L(:,ii),NEC_ratio_sparse_L(:,ii)];
    bar(dense_combined);
    xlabel('Number of Requests','FontSize',18,'FontWeight','bold');
    ylabel('Delay Satisfied Probability','FontSize',18,'FontWeight','bold');
    set(gca, 'XTick', 1:4);
    set(gca, 'XTickLabel', {'10','20','30','40'});
%     title(sprintf('Time-Slot=%d min',time_slot(ii)));
    ylim([0,1.35]);
    lgd=legend({'No Caching','All Caching','Optimal','NECC'},'Location','north');
    lgd.FontSize=18;
end

%average hop
load('dense_para.mat');
load('sparse_para.mat');
load('NEC.mat');

pi_mid=cell(size(MILP_No_cache_dense));
MILP_hop_dense=zeros(size(MILP_No_cache_dense));
NEC_hop_dense=MILP_hop_dense;
MILP_hop_sparse=NEC_hop_dense;
NEC_hop_sparse=MILP_hop_sparse;
for ii=1:size(MILP_No_cache_dense,1)
    for jj=1:size(MILP_No_cache_dense,2)
        % dense tree
        pi_mid{ii,jj}=squeeze(sum(sum(result_dense_L.result1{ii,jj}.sol.pi,4),3));
        MILP_hop_dense(ii,jj)=(squeeze(sum(pi_mid{ii,jj}*Hop'.*Pro(1:10*ii,:),'all'))*Ratio+15*(1-Ratio)*10*ii)/(10*ii);
        pi_mid{ii,jj}=squeeze(sum(sum(pi_NECC{ii}.sol.pi,4),3));
        NEC_hop_dense(ii,jj)=(squeeze(sum(pi_mid{ii,jj}*Hop'.*Pro(1:10*ii,:),'all'))*Ratio+15*(1-Ratio)*10*ii)/(10*ii);
        %sparse tree
        pi_mid{ii,jj}=squeeze(sum(sum(result_sparse_L.result1{ii,jj}.sol.pi,4),3));
        MILP_hop_sparse(ii,jj)=(squeeze(sum(pi_mid{ii,jj}*Hop'.*Pro(1:10*ii,:),'all'))*Ratio+15*(1-Ratio)*10*ii)/(10*ii);
        pi_mid{ii,jj}=squeeze(sum(sum(pi_NECC_s{ii}.sol.pi,4),3));
        NEC_hop_sparse(ii,jj)=(squeeze(sum(pi_mid{ii,jj}*Hop'.*Pro(1:10*ii,:),'all'))*Ratio+15*(1-Ratio)*10*ii)/(10*ii);        
    end
end
NoCache_hop=ones(size(MILP_No_cache_dense))*15;
AllCache_hop=ones(size(MILP_No_cache_dense))*3.8;

base=base+length(time_slot);

flow_plot=1:4;
figure(base+1);
hold on;
plot(flow_plot,log(NoCache_hop(:,1)),'-p','LineWidth',2,'MarkerSize',10);
plot(flow_plot,log(AllCache_hop(:,1)),'-+','LineWidth',2,'MarkerSize',10);
plot(flow_plot,log(MILP_hop_dense(:,1)),'-v','LineWidth',2,'MarkerSize',10);
plot(flow_plot,log(NEC_hop_dense(:,1)),'-o','LineWidth',2,'MarkerSize',10);
plot(flow_plot,log(MILP_hop_sparse(:,1)),'-^','LineWidth',2,'MarkerSize',10);
plot(flow_plot,log(NEC_hop_sparse(:,1)),'-d','LineWidth',2,'MarkerSize',10);
xlabel('Number of Requests','FontSize',18,'FontWeight','bold');
ylabel('ln(Avg. Hops)','FontSize',18,'FontWeight','bold');
lgd=legend({'No Caching','All Caching','EECQG-Dense','NECC-Dense','EECQG-Sparse','NECC-Sparse'},...
    'Location','north','NumColumns',3);
lgd.FontSize=18;
hold off;
ax = gca;
ax.XTick = 1:4;
ax.XTickLabel = {'10','20','30','40'};
ylim([1.2,3]);
set(gca, 'FontSize', 16);

figure(base+2);
hold on;
plot(flow_plot,log(NoCache_hop(:,2)),'-p','LineWidth',2,'MarkerSize',10);
plot(flow_plot,log(AllCache_hop(:,2)),'-+','LineWidth',2,'MarkerSize',10);
plot(flow_plot,log(MILP_hop_dense(:,2)),'-v','LineWidth',2,'MarkerSize',10);
plot(flow_plot,log(NEC_hop_dense(:,2)),'-o','LineWidth',2,'MarkerSize',10);
plot(flow_plot,log(MILP_hop_sparse(:,2)),'-^','LineWidth',2,'MarkerSize',10);
plot(flow_plot,log(NEC_hop_sparse(:,2)),'-d','LineWidth',2,'MarkerSize',10);
xlabel('Number of Requests','FontSize',18,'FontWeight','bold');
ylabel('ln(Avg. Hops)','FontSize',18,'FontWeight','bold');
lgd=legend({'No Caching','All Caching','EECQG-Dense','NECC-Dense','EECQG-Sparse','NECC-Sparse'},...
    'Location','north','NumColumns',3);
lgd.FontSize=18;
hold off;
ax = gca;
ax.XTick = 1:4;
ax.XTickLabel = {'10','20','30','40'};
ylim([1.2,3]);
set(gca, 'FontSize', 16);