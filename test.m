EECQG_total=zeros(1,5);
EECQG_satis_ratio=zeros(size(EECQG_total));
EECQG_hop_counter=zeros(size(EECQG_total));

NECC_total=zeros(size(EECQG_total));
NECC_satis_ratio=zeros(size(EECQG_total));
NECC_hop_counter=zeros(size(EECQG_total));

UniCach_total=zeros(size(EECQG_total));
UniCach_satis_ratio=zeros(size(EECQG_total));
UniCach_hop_counter=zeros(size(EECQG_total));

flow_scaling=1:5;

for ii=1:5
%     EECQG_total(ii)=sum(result2{ii,1}.total,'all');
%     EECQG_satis_ratio(ii)=sum(result2{ii,1}.cache_hit_num,'all')/(flow_scaling(ii)*20);
%     EECQG_hop_counter(ii)=sum(result2{ii,1}.hop_counter,'all')/(flow_scaling(ii)*20);
    NECC_total(ii)=sum(result3{ii,1}.total,'all');
    NECC_satis_ratio(ii)=sum(result3{ii,1}.cache_hit_num,'all')/(flow_scaling(ii)*20);
    NECC_hop_counter(ii)=sum(result3{ii,1}.hop_counter,'all')/(flow_scaling(ii)*20);
    UniCach_total(ii)=sum(result4{ii,1}.total,'all');
    UniCach_satis_ratio(ii)=sum(result3{ii,1}.cache_hit_num,'all')/(flow_scaling(ii)*20);
    UniCach_hop_counter(ii)=sum(result4{ii,1}.hop_counter,'all')/(flow_scaling(ii)*20);
end

linewidth=2.5;
markersize=12;
fontsize=20;
figure(1);
hold on;
plot(flow_scaling,EECQG_total,'-p','LineWidth',linewidth,'MarkerSize',markersize);
plot(flow_scaling,NECC_total,'-v','LineWidth',linewidth,'MarkerSize',markersize);
plot(flow_scaling,UniCach_total,'-d','LineWidth',linewidth,'MarkerSize',markersize);
grid on;
xlabel('Number of Requests','FontSize',fontsize,'FontWeight','bold');
ylabel('Energy Cons.(J)','FontSize',fontsize,'FontWeight','bold');
lgd=legend({'EECQG','NECC','UniCach'},'Location','northwest');
lgd.FontSize=fontsize;
hold off;
ax = gca;
ax.XTick = 1:5;
ax.XTickLabel = {'20','40','60','80','100'};
set(gca, 'FontSize', fontsize);

figure(2);
hold on;
plot(flow_scaling,log(EECQG_hop_counter),'-p','LineWidth',linewidth,'MarkerSize',markersize);
plot(flow_scaling,log(NECC_hop_counter),'-v','LineWidth',linewidth,'MarkerSize',markersize);
plot(flow_scaling,log(UniCach_hop_counter),'-d','LineWidth',linewidth,'MarkerSize',markersize);
grid on;
xlabel('Number of Requests','FontSize',fontsize,'FontWeight','bold');
ylabel('Mean hops','FontSize',fontsize,'FontWeight','bold');
lgd=legend({'EECQG','NECC','UniCach'},'Location','northwest');
lgd.FontSize=fontsize;
hold off;
ax = gca;
ax.XTick = 1:5;
ax.XTickLabel = {'20','40','60','80','100'};
set(gca, 'FontSize', fontsize);

delay_satis=[EECQG_satis_ratio',NECC_satis_ratio',UniCach_satis_ratio'];
figure(3);
bar(delay_satis,0.75);
xlabel('Number of Requests','FontSize',fontsize,'FontWeight','bold');
ylabel('Satisfied Probability','FontSize',fontsize,'FontWeight','bold');
ylim([0,1.05]);
set(gca,'xtick',1:5,'xticklabel',{'20','40','60','80','100'},'FontSize',fontsize);
lgd=legend({'EECQG','NECC','UniCach'},'location','north','NumColumns',3);
lgd.FontSize=fontsize;
