close all;
clear;
clc;

No_Caching=[13554.91679,27109.83357,40664.75036,54219.66714,67774.58393;
 0.5,0.5,0.5,0.5,0.5;
 15,15,15,15,15];

All_Caching=[10796.48096,14230.39321,17664.30547,21098.21772,24532.12997;
 0.9,0.9,0.9,0.9,0.9;
 3.8,3.8,3.8,3.8,3.8];

Uni_Caching=[9288.478768,11822.66944,14356.86011,16891.05078,19425.24145;
0.9,0.9,0.864,0.782,0.745;
4.2,4.2,4.2,4.2,4.2];

NECC=[6700.357814,10133.07097,12219.53307,15788.24723,18795.2381;
0.9,0.9,0.9,0.88,0.865;
4.9,4.9,4.9,4.9,4.9];

EECQG=[6700.357814,9592.6858,11478.44821,13476.6368,15735.345;
0.9,0.9,0.9,0.9,0.9;
4.9,4.5,4.5,4.1,4.1  
];

ratio=[0.3986,0.3458,0.3103,0.3227,0.2937];

flow_plot=1:5;

line_width=2.5;
marker_size=12;
font_size=20;
figure(1);
hold on;
plot(flow_plot,No_Caching(1,:),'-p','LineWidth',line_width,'MarkerSize',marker_size);
plot(flow_plot,All_Caching(1,:),'-v','LineWidth',line_width,'MarkerSize',marker_size);
plot(flow_plot,Uni_Caching(1,:),'-*','LineWidth',line_width,'MarkerSize',marker_size);
plot(flow_plot,NECC(1,:),'-o','LineWidth',line_width,'MarkerSize',marker_size);
plot(flow_plot,EECQG(1,:),'-d','LineWidth',line_width,'MarkerSize',marker_size);
grid on;
xlabel('Number of Requests','FontSize',font_size,'FontWeight','bold');
ylabel('Energy Cons.(J)','FontSize',font_size,'FontWeight','bold');
lgd=legend({'NoCach','AllCach','UniCach','NECC','EECQG'},'Location','northwest');
lgd.FontSize=font_size;
hold off;
ax = gca;
ax.XTick = 1:5;
ax.XTickLabel = {'20','40','60','80','100'};
set(gca, 'FontSize', font_size);

figure(2);
hold on;
plot(flow_plot,EECQG(1,:),'-d','LineWidth',line_width,'MarkerSize',marker_size);
plot(flow_plot,EECQG(1,:).*ratio,'-s','LineWidth',line_width,'MarkerSize',marker_size);
plot(flow_plot,EECQG(1,:).*(1-ratio),'-h','LineWidth',line_width,'MarkerSize',marker_size);
grid on;
xlabel('Number of Requests','FontSize',font_size,'FontWeight','bold');
ylabel('Energy Cons.(J)','FontSize',font_size,'FontWeight','bold');
lgd=legend({'Overall','Caching','Trasmission'},'Location','north','NumColumns',3);
lgd.FontSize=font_size;
hold off;
ax = gca;
ax.XTick = 1:5;
ax.XTickLabel = {'20','40','60','80','100'};
set(gca, 'FontSize', font_size);

delay_satis=[No_Caching(2,:)',All_Caching(2,:)',Uni_Caching(2,:)',NECC(2,:)',EECQG(2,:)'];
figure(3);
bar(delay_satis,0.75);
xlabel('Number of Requests','FontSize',font_size,'FontWeight','bold');
ylabel('Satisfied Probability','FontSize',font_size,'FontWeight','bold');
ylim([0,1.05]);
set(gca,'xtick',1:5,'xticklabel',{'20','40','60','80','100'},'FontSize',font_size);
lgd=legend({'NoCach','AllCach','UniCach','NECC','EECQG'},'location','north','NumColumns',5);
lgd.FontSize=font_size;

figure(4);
hold on;
plot(flow_plot,log(No_Caching(3,:)),'-p','LineWidth',line_width,'MarkerSize',marker_size);
plot(flow_plot,log(All_Caching(3,:)),'-v','LineWidth',line_width,'MarkerSize',marker_size);
plot(flow_plot,log(Uni_Caching(3,:)),'-*','LineWidth',line_width,'MarkerSize',marker_size);
plot(flow_plot,log(NECC(3,:)),'-o','LineWidth',line_width,'MarkerSize',marker_size);
plot(flow_plot,log(EECQG(3,:)),'-d','LineWidth',line_width,'MarkerSize',marker_size);
grid on;
xlabel('Number of Requests','FontSize',font_size,'FontWeight','bold');
ylabel('ln(Avg. Hops)','FontSize',font_size,'FontWeight','bold');
lgd=legend({'NoCach','AllCach','UniCach','NECC','EECQG'},'Location','north','NumColumns',5);
lgd.FontSize=font_size;
hold off;
ax = gca;
ax.XTick = 1:5;
ax.XTickLabel = {'20','40','60','80','100'};
ylim([1.2,3]);
set(gca, 'FontSize', font_size);
