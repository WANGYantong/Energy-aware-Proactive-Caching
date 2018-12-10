clear
clc

addpath(genpath(pwd));

%% Generate Network
[G,EdgeCloud,NormalRouter,AccessRouter,vertice_names]=SetNetTopo();
N=length(vertice_names);
for v=1:N
    eval([vertice_names{v},'=',num2str(v),';']);
end

%% Construct Network Flow
step=4;
flow=1:20;
NF=length(flow)/step;

NF_TOTAL=20;

flow_parallel=cell(NF,1);
for ii=1:NF
    flow_parallel{ii}=flow(1:ii*step);
end

%% Produce Netwrok Parameters
%%%%%% relax the bandwidth constraint currently %%%%%%

data.N_e=2; % number of servers on EC
data.N_es=4; % number of VMs in servers on EC
data.SC=50*1024; % size of caching content, Unit: MB
data.S_k=randi([5,10],size(flow))*102.4; % size of request content, Unit: MB
mid_array=[5,5,5,5,5,10,10,10,10,10];
data.delay_k=repmat(mid_array,1,NF); % delay tolerance of flow

% user movement probability
probability=zeros(NF_TOTAL,length(AccessRouter));
for ii=1:NF_TOTAL
    probability(ii,length(AccessRouter))=1;
    for jj=1:length(AccessRouter)-1
        probability(ii,jj)=rand()/(length(AccessRouter)-1);
        probability(ii,length(AccessRouter))=...
            probability(ii,length(AccessRouter))-probability(ii,jj);
    end
    index=randi(length(AccessRouter));
    buffer=probability(ii,length(AccessRouter));
    probability(ii,length(AccessRouter))=probability(ii,index);
    probability(ii,index)=buffer;
end
data.probability_ka=probability;

% processing capacity of VM 
data.mu_esv=randi([2,4],length(EdgeCloud),data.N_e,data.N_es); 

% idle power of server, unit: Watt
data.U_es=ones(length(EdgeCloud),data.N_e)*95.92;

% power consumption of VM
data.U_esv=ones(length(EdgeCloud),data.N_e,data.N_es)*16.02;

% power efficiency of storage
data.W_C=10^(-9)*8*1024*1024;

% power efficiency of transmission
data.W_T=2*10^(-8)*8*1024*1024;

% shortes hop matrix
data.N=zeros(length(AccessRouter),length(EdgeCloud));
for ii=1:length(AccessRouter)
    for jj=1:length(EdgeCloud)
        [~,data.N(ii,jj)]=shortestpath(G,AccessRouter(ii),EdgeCloud(jj));
    end
end

data.M=10; % the number of hop if cache missing 

% caching ratio
data.R=0.7;

para.EdgeCloud=EdgeCloud;
para.AccessRouter=AccessRouter;
para.NormalRouter=NormalRouter;
%% Optimal Solution
result=cell(NF,1);
parfor ii=1:NF
    result{ii}=MILP(flow_parallel{ii},data,para);
end

%% 

EC=zeros(NF,1);
ET=zeros(NF,1);
cost=zeros(NF,1);
for ii=1:NF
    EC(ii)=result{ii}.sol.EC/1000;
    ET(ii)=result{ii}.sol.ET/1000;
    cost(ii)=result{ii}.value/1000;
end
flow_plot=1:4:20;

figure(2);
hold on;
plot(flow_plot,cost,'-p','Color',[0.85,0.33,0.10],'LineWidth',3.6);
plot(flow_plot,ET,'-+','Color',[0.30,0.75,0.93],'LineWidth',3.6);
plot(flow_plot,EC,'-^','Color',[0.64,0.08,0.18],'LineWidth',3.6);
xlabel('Number of flows');
ylabel('Energy Consumption (KW)');
lgd=legend({'Total Energy','Transmission Energy','Caching Energy'},...
    'location','north');
lgd.FontSize=24;
hold off;

NumSer=zeros(NF,1);
NumVM=zeros(NF,1);
for ii=1:NF
    NumSer(ii)=sum(sum(result{ii}.sol.y~=zeros(length(EdgeCloud),data.N_e)));
    NumVM(ii)=sum(sum(sum(result{ii}.sol.x~=zeros(length(EdgeCloud),data.N_e,data.N_es))));
end
figure(3);
hold on;
outage=[NumSer,NumVM];
figure(3);
bar(outage,1);
xlabel('Number of flows');
ylabel('Number of Openning Equipment');
set(gca,'xtick',1:5,'xticklabel',{'1','5','9','13','17'});
lgd=legend({'Server','Virtual Machine'},'location','north');
lgd.FontSize=24;
hold off;