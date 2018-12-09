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
step=10;
flow=1:50;
NF=length(flow)/step;

NF_TOTAL=50;

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
for ii=1:NF
    result{ii}=MILP(flow_parallel{ii},data,para);
end



