clear
clc
rng(1);

%% Generate Network Topology
vertice_name={'R1','R2','R3','R4','R5'};
numNode=length(vertice_name);

for v=1:numNode
    eval([vertice_name{v},'=',num2str(v),';']);
end

NormalRouter=R1:R3;
AccessRouter=NormalRouter;
EdgeCloud=R4:R5;
AllNode=R1:R5;

s=[R5,R5,R4,R4];
t=[R4,R3,R1,R2];

weight=ones(size(s));
figure(1);
G=graph(s,t,weight,vertice_name);
h=plot(G,'NodeLabel',G.Nodes.Name);
h.XData=[1,3,5,2,3];
h.YData=[1,1,1,2,3];

data.N=zeros(length(AccessRouter),length(EdgeCloud));
data.path=cell(length(AccessRouter),length(EdgeCloud));
for ii=1:length(AccessRouter)
    for jj=1:length(EdgeCloud)
        [data.path{ii,jj},data.N(ii,jj)]=shortestpath(G,AccessRouter(ii),EdgeCloud(jj));
    end
end

data.probability_ka=GnrMovPro(6,length(AccessRouter),'RM');

para.graph=G;
para.NormalRouter=NormalRouter;
para.EdgeCloud=EdgeCloud;
%% Produce Routers and Mobile Users
end_user=cell(6,1);
for ii=1:6
    user_setting.id=ii;
    user_setting.probability=data.probability_ka(ii,:);
    user_setting.access_router=AccessRouter;
    user_setting.interest=ii*2;
    user_setting.born_time=clock;
    user_setting.delay=5;
    user_setting.ec=EdgeCloud(randi(2));
    user_setting.server=1;
    user_setting.vm=1;
    
    end_user{ii}=EndUserClass(user_setting);
end

router_setting=cell(5,1);
router=cell(size(router_setting));
for ii=1:length(router_setting)
    router_setting{ii}.id=AllNode(ii);
    router_setting{ii}.connection=neighbors(para.graph, router_setting{ii}.id);
    router_setting{ii}.path=data.path;
    router_setting{ii}.ec=para.EdgeCloud;
    router{ii}=RouterClass(router_setting{ii});
end

listening_list=[end_user{1},end_user{2},end_user{3},end_user{4},end_user{5},end_user{6}];

for ii=1:3
    router{ii}.setlistener(listening_list);
end

router{4}.setlistener([router{1},router{2},router{5}]); 
router{5}.setlistener([router{3},router{4}]);

end_user{1}.produce; % mobile user 1 send request
pause(5);
end_user{2}.produce;
pause(5);
end_user{3}.produce;
pause(5);
end_user{4}.produce;
pause(5);
end_user{5}.produce;
pause(5);
end_user{6}.produce;
