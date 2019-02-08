clear
clc
rng(1);

cd ..;
addpath(genpath(pwd));
cd NetSim\;
%% Generate Network Topology
vertice_name={'R1','R2','R3','R4','EC1','EC2'};
numNode=length(vertice_name);

for v=1:numNode
    eval([vertice_name{v},'=',num2str(v),';']);
end

NormalRouter=R1:R4;
AccessRouter=R1:R3;
EdgeCloud=EC1:EC2;

s=[EC2,EC2,EC1,EC1,R4];
t=[EC1,R4,R1,R2,R3];

weight=ones(size(s));
figure(1);
G=graph(s,t,weight,vertice_name);
h=plot(G,'NodeLabel',G.Nodes.Name);
h.XData=[1,3,5,4,2,3];
h.YData=[1,1,1,2,2,3];

data.N=zeros(length(AccessRouter),length(EdgeCloud));
data.path=cell(length(AccessRouter),length(EdgeCloud));
for ii=1:length(AccessRouter)
    for jj=1:length(EdgeCloud)
        [data.path{ii,jj},data.N(ii,jj)]=shortestpath(G,AccessRouter(ii),EdgeCloud(jj));
    end
end

data.probability_ka=GnrMovPro(20,length(AccessRouter),'RM');

para.graph=G;
para.NormalRouter=NormalRouter;
para.EdgeCloud=EdgeCloud;
%% Produce Routers, Mobile Users and Edge Clouds
% mobile users
NU=20; %number of users
interest=zipfrnd(0.8,100,NU);%generate interest content
end_user=cell(1,NU);
delay_vector=[0.5,1];
for ii=1:NU
    user_setting.id=ii;
    user_setting.probability=data.probability_ka(ii,:);
    user_setting.access_router=AccessRouter;
    user_setting.interest=interest(ii);
    user_setting.delay=delay_vector(randi(2));
    user_setting.ec=EdgeCloud(randi(2));
    user_setting.server=1;
    user_setting.vm=1;
    
    end_user{ii}=EndUserClass(user_setting);
end
%routers
router_setting=cell(length(NormalRouter),1);
router=cell(size(router_setting));
for ii=1:length(router_setting)
    router_setting{ii}.id=NormalRouter(ii);
    router_setting{ii}.connection=neighbors(para.graph, router_setting{ii}.id);
    router_setting{ii}.path=data.path;
    router_setting{ii}.ec=para.EdgeCloud;
    router{ii}=RouterClass(router_setting{ii});
end
%edgeclouds
ec_setting=cell(length(EdgeCloud),1);
edgeclouds=cell(size(ec_setting));
for ii=1:length(ec_setting)
    ec_setting{ii}.id=EdgeCloud(ii);
    ec_setting{ii}.connection=neighbors(para.graph, ec_setting{ii}.id);
    ec_setting{ii}.path=data.path;
    ec_setting{ii}.ec=para.EdgeCloud;
    ec_setting{ii}.numServer=2;
    ec_setting{ii}.numVM=4;
    ec_setting{ii}.sizeBuffer=size(end_user);
    ec_setting{ii}.mu=20;
    edgeclouds{ii}=EdgeCloudClass(ec_setting{ii});
end

% add monitors to events
listening_list=[end_user{1:end}];

for ii=1:3
    router{ii}.setlistener(listening_list);
end

router{4}.setlistener([router{3}]); 
router{4}.setlistener([edgeclouds{2}]); 
edgeclouds{1}.setlistener([router{1},router{2}]);
edgeclouds{1}.setlistener([edgeclouds{2}]);
edgeclouds{2}.setlistener([router{4}]);
edgeclouds{2}.setlistener([edgeclouds{1}]);

dt=exprnd(1/NU,1,NU);

for ii=1:NU
    end_user{ii}.produce;
    if ii<NU
        pause(dt(ii));
    else
        continue;
    end
end


edgeclouds{1}.processBuffer;
edgeclouds{2}.processBuffer;