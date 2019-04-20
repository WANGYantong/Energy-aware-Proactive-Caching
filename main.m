clear
clc

addpath(genpath(pwd));
% rng(1);
%% Generate Network
[G,EdgeCloud,NormalRouter,AccessRouter,vertice_names]=SetNetTopo(1);
N=length(vertice_names);
for v=1:N
    eval([vertice_names{v},'=',num2str(v),';']);
end

%% Construct Network Flow for Each Time Slot

%Time slot duration, unit: second
% data.DeltaT=60*1;

%Request Flow
step=20;
flow=1:100;
NF=length(flow)/step;

NF_TOTAL=200;

flow_parallel=cell(NF,1);
for ii=1:NF
    flow_parallel{ii}=flow(1:ii*step);
end
 
%% Produce Netwrok Parameters
%%%%%% relax the bandwidth constraint currently %%%%%%

% simulation period: second
time_slot_scalling=10;

data.N_e=2; % number of servers on EC
data.N_es=4; % number of VMs in servers on EC
data.SC=10*1024; % size of caching content, Unit: MB
% data.S_k=randi([5,10],size(flow))*102.4; % size of request content, Unit: MB
data.S_k=ones(size(flow))*1*102.4;
data.B_l=2*1024*ones(length(G.Edges.Weight),1); % link available bandwidth, Unit:Mbps
data.T_k=randi([1,10],size(flow)); % required transmission rate
% data.T_k=ones(size(flow)); 
mid_array=[0.5,1,1,1,1,3,3,5,5,5]/time_slot_scalling;
% mid_array=ones(1,10)*0.5;
data.delay_k=repmat(mid_array,1,NF_TOTAL/length(mid_array)); % delay tolerance of flow

% user movement probability option
moving_opts={'RL','RH','RHD','RM','CL','CH','CHD'};

% data.mu_esv=randi([2,4],length(EdgeCloud),data.N_e,data.N_es)*10; 
% data.mu_esv=ones(length(EdgeCloud),data.N_e,data.N_es)*20.2;

% idle power of server, unit: Watt
data.U_es=ones(length(EdgeCloud),data.N_e)*95.92*time_slot_scalling;

% power consumption of VM, unit: Watt
data.U_esv=ones(length(EdgeCloud),data.N_e,data.N_es)*16.02*time_slot_scalling;

% power efficiency of storage(SSD):Watts
data.W_C=6.25*10^(-12)*8*1024*1024*time_slot_scalling;

% power efficiency of transmission
data.W_T=2.63*10^(-8)*8*1024*1024;
% data.W_T=1.88*10^(-7)*8*1024*1024;

% shortes hop matrix
data.N=zeros(length(AccessRouter),length(EdgeCloud));
data.path=cell(length(AccessRouter),length(EdgeCloud));
for ii=1:length(AccessRouter)
    for jj=1:length(EdgeCloud)
        [data.path{ii,jj},data.N(ii,jj)]=shortestpath(G,AccessRouter(ii),EdgeCloud(jj));
    end
end

data.beta=GetPathLinkRel(G,"undirected",data.path,length(AccessRouter),length(EdgeCloud));

data.M=15; % the number of hop if cache missing 

% caching ratio option
cache_ratio=[0.7,0.8,1];
data.R=cache_ratio(2);

para.graph=G;
para.EdgeCloud=EdgeCloud;
para.AccessRouter=AccessRouter;
para.NormalRouter=[GW,NormalRouter];
%% Optimal Solution
data.probability_ka=GnrMovPro(NF_TOTAL,length(AccessRouter),moving_opts{4});
%cheating scenario producing
pro_replace=GnrMovPro(50,length(AccessRouter),moving_opts{5},1);
for ii=1:5
    data.probability_ka((11+20*(ii-1)):(20+20*(ii-1)),:)=pro_replace((1+10*(ii-1)):(10+10*(ii-1)),:);
end

time_slot=[1,3,5];

result1=cell(NF,length(time_slot));
result2=cell(size(result1));
result3=cell(size(result1));
result4=cell(size(result1));
% load('result\sparse.mat');

Monte_Iterations=1000;
alpha=0.8;
LibSIZE=100;
ProcessingTIME=0.001/time_slot_scalling;

for jj=1:3
%     data.DeltaT=60*time_slot(jj);
    data.DeltaT=1;
    data.mu_esv=ones(length(EdgeCloud),data.N_e,data.N_es)*57.85; % service rate (per second)
%     data.mu_esv=ones(length(EdgeCloud),data.N_e,data.N_es)*2.88*data.DeltaT; % service rate (per second)
    parfor ii=1:NF
        buff1=MILP(flow_parallel{ii},data,para);
%         buff2=NetSimPlat(flow_parallel{ii},data,para,buff1.sol.pi,10);
        result1{ii,jj}=buff1;
        buff2=NetSimPlat(0,flow_parallel{ii},data,para,buff1.sol.pi,Monte_Iterations,alpha,LibSIZE,ProcessingTIME);
        result2{ii,jj}=buff2;
        
        buff1=NEC(flow_parallel{ii},data,para);
        buff2=NetSimPlat(0,flow_parallel{ii},data,para,buff1.sol.pi,Monte_Iterations,alpha,LibSIZE,ProcessingTIME);
        result3{ii,jj}=buff2;
        
        buff1=RDM(flow_parallel{ii},data,para);       
        buff2=NetSimPlat(1,flow_parallel{ii},data,para,buff1,Monte_Iterations,alpha,LibSIZE,ProcessingTIME);
        result4{ii,jj}=buff2;        
    end
end

save('result\sparse.mat','result1','result2','result3','result4');

% if data.R==cache_ratio(1)
%     buffer=result;
%     if ispc
%         save('result\result_R6.mat','buffer');
%     elseif isunix
%         save('result/result_R6.mat','buffer');
%     end
% end

%% 

% EC=zeros(NF,1);
% ET=zeros(NF,1);
% cost=zeros(NF,1);
% for ii=1:NF
%     EC(ii)=result{ii}.sol.EC/1000;
%     ET(ii)=result{ii}.sol.ET/1000;
%     cost(ii)=result{ii}.value/1000;
% end
% flow_plot=1:4:20;
% 
% figure(2);
% hold on;
% plot(flow_plot,cost,'-p','Color',[0.85,0.33,0.10],'LineWidth',3.6);
% plot(flow_plot,ET,'-+','Color',[0.30,0.75,0.93],'LineWidth',3.6);
% plot(flow_plot,EC,'-^','Color',[0.64,0.08,0.18],'LineWidth',3.6);
% xlabel('Number of flows');
% ylabel('Energy Consumption (KW)');
% lgd=legend({'Total Energy','Transmission Energy','Caching Energy'},...
%     'location','north');
% lgd.FontSize=24;
% hold off;
% 
% NumSer=zeros(NF,1);
% NumVM=zeros(NF,1);
% for ii=1:NF
%     NumSer(ii)=sum(sum(result{ii}.sol.y~=zeros(length(EdgeCloud),data.N_e)));
%     NumVM(ii)=sum(sum(sum(result{ii}.sol.x~=zeros(length(EdgeCloud),data.N_e,data.N_es))));
% end
% figure(3);
% hold on;
% outage=[NumSer,NumVM];
% figure(3);
% bar(outage,1);
% xlabel('Number of flows');
% ylabel('Number of Openning Equipment');
% set(gca,'xtick',1:5,'xticklabel',{'1','5','9','13','17'});
% lgd=legend({'Server','Virtual Machine'},'location','north');
% lgd.FontSize=24;
% hold off;