router_setting=cell(length(para.NormalRouter),1);
router=cell(size(router_setting));
for ii=1:length(router_setting)
    router_setting{ii}.id=NormalRouter(ii);
    router_setting{ii}.connection=neighbors(para.graph, router_setting{ii}.id);
    router_setting{ii}.path=data.path;
    router_setting{ii}.ec=para.EdgeCloud;
    router{ii}=Router(router_setting{ii});
end

user_setting.id=10;
user_setting.probability=data.probability_ka(1,:);
user_setting.access_router=AccessRouter;
user_setting.interest=98;
user_setting.born_time=clock;
user_setting.delay=data.delay_k(user_setting.id);
user_setting.ec=2;
user_setting.server=1;
user_setting.vm=1;
end_user=End_User(user_setting);
