function result = NetSimPlat(flow, data, para, assign,...
    MonteTIME, alpha, LibSIZE, ProcessingTIME)
%NETSIMPLAT Summary of this function goes here
%   A RAN simulator based on OOP.
%
%   Input:    
%               flow: the set of content request;
%               data:
%               para:
%               assign: decision variable to combine user request and ec,
%                           server&vm, i.e. decision variable pi
%               MonteTIME: the repitition times of Monte Carlo simulation
%               alpha: the arguement for Zipf distribution
%               LibSIZE: total number of contents hosted in data server
%               CacheRATIO:
%               ProcessingTIME:
%
%   Output:
%               
%

if nargin<4
    error('Not Enough Input Arguements!');
end
if nargin<=7
    ProcessingTIME=0.01;
end
if nargin <= 6
    LibSIZE=100;
end
if nargin <= 5
    alpha=0.8;
end
if nargin <=4
    MonteTIME=1000;
end
    
NF=length(flow);

end_user=cell(1,NF);
normal_router=cell(1,length(para.NormalRouter));
edge_cloud=cell(1,length(para.EdgeCloud));

% container for result of each Monte Carlo loop
trans_energy=zeros(MonteTIME,length(para.EdgeCloud));
cache_energy=zeros(size(trans_energy));
total_energy=zeros(size(trans_energy));

user_num=zeros(MonteTIME,length(para.EdgeCloud),data.N_e,data.N_es);            % servered user in VM
cache_hit_num=zeros(size(user_num));    % cache hitted user in VM
delay_satis_num=zeros(size(user_num));  % QoS satisfied user in VM

sojourn_total=zeros(size(user_num));      % total sojourn time of this VM
sojourn_mean=zeros(size(user_num));    % average sojourn time of this VM
busy_ratio=zeros(size(user_num));          % VM busy time probability

% get the index of ec+server+vm of assignment
r=zeros(1,NF);
c=zeros(1,NF);
v=zeros(1,NF);
for ii=1:NF
    QQ=squeeze(assign(ii,:,:,:));
    [r(ii),c(ii),v(ii)]=ind2sub(size(QQ),find(QQ));
    r(ii)=para.EdgeCloud(r(ii)); % pair the index and value!!!
end

for nn=1:MonteTIME
    
    %produce interest content
    [interest,Prob]=zipfrnd(alpha,LibSIZE,NF);
    for idx=1:LibSIZE
        if sum(Prob(1:idx))>=data.R
            break;
        end
    end
    
    %generate mobile users
    for ii=1:NF
        user_setting.id=ii;
        user_setting.probability=data.probability_ka(ii,:);
        user_setting.access_router=para.AccessRouter;
        user_setting.interest=interest(ii);
        user_setting.delay=data.delay_k(ii);
        user_setting.ec=r(ii);
        user_setting.server=c(ii);
        user_setting.vm=v(ii);
        user_setting.content_size=data.S_k(ii);
        
        end_user{ii}=EndUserClass(user_setting);
    end
    
    % construct normal routers 
    for ii=1:length(normal_router)
        router_setting.id=para.NormalRouter(ii);
        router_setting.connection=neighbors(para.graph, router_setting.id);
        router_setting.path=data.path;
        router_setting.ec=para.EdgeCloud;
        router_setting.name_table=para.graph.Nodes.Name;
        router_setting.time=ProcessingTIME;
        normal_router{ii}=RouterClass(router_setting);
    end
    
    % build edge clouds
    for ii=1:length(edge_cloud)
        ec_setting.id=para.EdgeCloud(ii);
        ec_setting.connection=neighbors(para.graph, ec_setting.id);
        ec_setting.path=data.path;
        ec_setting.ec=para.EdgeCloud;
        ec_setting.name_table=para.graph.Nodes.Name;
        ec_setting.num_server=data.N_e;
        ec_setting.num_vm=data.N_es;
        ec_setting.size_buffer=size(end_user);
        ec_setting.mu=squeeze(data.mu_esv(ii,:,:));
        ec_setting.time=ProcessingTIME;
        ec_setting.content=idx;
        ec_setting.retrieval_time=mean(data.delay_k);
        ec_setting.retrieval_hop=data.M;
        ec_setting.server_ee=data.U_es(ii,1);
        ec_setting.vm_ee=data.U_esv(ii,1,1);
        ec_setting.cache_ee=data.W_C;
        ec_setting.cache_size=data.SC;
        ec_setting.time_slot=data.DeltaT;
        ec_setting.trans_ee=data.W_T;
        
        edge_cloud{ii}=EdgeCloudClass(ec_setting);
    end
    
    % add monitors to events
    listening_list=[end_user{1:end}];
    
    for ii=1:length(normal_router)
        normal_router{ii}.SetListener(listening_list);
        around=neighbors(para.graph, normal_router{ii}.id);
        [~,col_router]=find(para.NormalRouter==around);
        [~,col_ec]=find(para.EdgeCloud==around);
                
       for kk=1:length(col_router)
           normal_router{ii}.SetListener(normal_router{col_router(kk)});
       end
       for kk=1:length(col_ec)
           normal_router{ii}.SetListener(edge_cloud{col_ec(kk)});
       end
    end 
    
    for ii=1:length(edge_cloud)
        edge_cloud{ii}.SetListener(listening_list);
        around=neighbors(para.graph, edge_cloud{ii}.id);
        [~,col_router]=find(para.NormalRouter==around);
        [~,col_ec]=find(para.EdgeCloud==around);
        
        for kk=1:length(col_router)
            edge_cloud{ii}.SetListener(normal_router{col_router(kk)});
        end
        for kk=1:length(col_ec)
            edge_cloud{ii}.SetListener(edge_cloud{col_ec(kk)});
        end
    end
    
    % send package of each mobile user
%     dt=exprnd(data.DeltaT/NF,1,NF);
    dt=exprnd((data.DeltaT-max(data.delay_k))/NF,1,NF);
    for ii=1:NF
        end_user{ii}.Produce;
        if ii<NF
            pause(dt(ii));
        else
            continue;
        end
    end
    
    % deal with request by each edge cloud
    for ii=1:length(edge_cloud)
        edge_cloud{ii}.ProcessBuffer;
    end
    
    % calculate result
    for ii=1:length(edge_cloud)
         [trans_energy(nn,ii),total_energy(nn,ii)]=edge_cloud{ii}.EnergyEstimate;
         cache_energy(nn,ii)=total_energy(nn,ii)-trans_energy(nn,ii);
         
         user_num(nn,ii,:,:)=edge_cloud{ii}.user_num;
         cache_hit_num(nn,ii,:,:)=edge_cloud{ii}.cache_hit_num;
         delay_satis_num(nn,ii,:,:)=edge_cloud{ii}.delay_satis_num;
         sojourn_total(nn,ii,:,:)=edge_cloud{ii}.sojourn_total;
         sojourn_mean(nn,ii,:,:)=edge_cloud{ii}.sojourn_mean;
         busy_ratio(nn,ii,:,:)=edge_cloud{ii}.busy_ratio;
    end
    
end

result.trans=mean(trans_energy,1);
result.cache=mean(cache_energy,1);
result.total=mean(total_energy,1);
result.user_num=squeeze(mean(user_num,1));
result.cache_hit_num=squeeze(mean(cache_hit_num,1));
result.delay_satis_num=squeeze(mean(delay_satis_num,1));
result.sojourn_total=squeeze(mean(sojourn_total,1));
result.sojourn_mean=squeeze(mean(sojourn_mean,1));
result.busy_ratio=squeeze(mean(busy_ratio,1));

end

