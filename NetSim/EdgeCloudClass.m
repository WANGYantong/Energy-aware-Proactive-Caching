classdef EdgeCloudClass < RouterClass
    %EDGE_CLOUD Summary of this class goes here
    
    properties
        buffer;           % waiting list for coming request
        mu;               % ability to deal with request, measured by processing time
        cache_threshold;     % caching content library
        retrieval_time;    % added latency when cache miss
        retrieval_hop;     % added hops when cache miss
        server_ee;          % server energy efficiency (Watt)
        vm_ee;              % virtual machine energy efficiency (Watt)
        cache_ee;          % caching energy efficiency (Watt per MB)
        cache_size;        % the library size caching in this edge cloud (MB)
        time_slot;          % the period for opening edge cloud(second)
        trans_ee;           % energy efficiency for transmission (Watt per [MB*hop])
        
        user_num;           % servered user in VM
        cache_hit_num;   % cache hitted user in VM
        delay_satis_num; % QoS satisfied user in VM
        
        sojourn_total; % total sojourn time of this VM
        sojourn_mean; % average sojourn time of this VM
        busy_ratio; % VM busy time probability
    end
    
    methods
        function obj = EdgeCloudClass(ec_setting)
            %EDGE_CLOUD Construct an instance of this class
            obj@RouterClass(ec_setting);
            obj.buffer=cell(ec_setting.num_server,ec_setting.num_vm);
            for ii=1:ec_setting.num_server
                for jj=1:ec_setting.num_vm
                    obj.buffer{ii,jj}=cell(ec_setting.size_buffer);
                end
            end
            obj.mu=ec_setting.mu;
            obj.cache_threshold=ec_setting.content;
            obj.retrieval_time=ec_setting.retrieval_time;
            obj.retrieval_hop=ec_setting.retrieval_hop;
            obj.server_ee=ec_setting.server_ee;
            obj.vm_ee=ec_setting.vm_ee;
            obj.cache_ee=ec_setting.cache_ee;
            obj.cache_size=ec_setting.cache_size;
            obj.time_slot=ec_setting.time_slot;
            obj.trans_ee=ec_setting.trans_ee;
            
            obj.user_num=zeros(size(obj.buffer));
            obj.cache_hit_num=zeros(size(obj.buffer));
            obj.delay_satis_num=zeros(size(obj.buffer));
            obj.sojourn_total=zeros(size(obj.buffer));
            obj.sojourn_mean=zeros(size(obj.buffer));
            obj.busy_ratio=zeros(size(obj.buffer));
        end
        
        function SendingHandle(obj,~,eventData)
            if obj.id==eventData.package{2}{2}  % the package is send to this router
                if obj.id==eventData.package{2}{3} % this router is the final destination
                    if obj.debug
                        fprintf('Package %d is received by %s\n',eventData.package{1},obj.name_table{obj.id});
                    end
                    obj.PutInBuffer(eventData.package);
                    serverIdx=eventData.package{2}{4};
                    vmIdx=eventData.package{2}{5}; 
                    obj.user_num(serverIdx,vmIdx)=obj.user_num(serverIdx,vmIdx)+1;
                else                          % relay the package
                    if obj.debug
                        fprintf('Package %d is relayed by %s\n',eventData.package{1},obj.name_table{obj.id});
                    end
                    pause(obj.time);             % pretend processing delay+propogation delay
                    index=find(obj.forward(:,2)==eventData.package{2}{3});
                    eventData.package{2}{2}=obj.forward(index,1);            % update the next hop destination according to forward map
                    eventData.package{3}{3}=clock;            % update the time stamp
                    eventData.package{2}{6}=eventData.package{2}{6}+1; % update hop counter
                    notify(obj,'sending',DeliveryPackageClass(eventData.package));
                end
            end
        end
        
        function PutInBuffer(obj,package)
            serverIdx=package{2}{4};
            vmIdx=package{2}{5};        %locate the buffer
            package{3}{3}=clock;         %update time stamp 
            for ii=1:length(obj.buffer{serverIdx,vmIdx})
                if isempty(obj.buffer{serverIdx,vmIdx}{ii})
                    obj.buffer{serverIdx,vmIdx}{ii}=package;
                    break;
                end
            end
        end
        
        function ProcessBuffer(obj)
            for ii=1:size(obj.buffer,1)
                for jj=1:size(obj.buffer,2)
                    if isempty(obj.buffer{ii,jj}{1})
                        continue;
                    end
                    
                    for nn=1:length(obj.buffer{ii,jj})
                        if isempty(obj.buffer{ii,jj}{nn})
                            break;
                        end
                    end
                    if nn<length(obj.buffer{ii,jj})
                        nn=nn-1;
                    end
                    
                    dt=zeros(1,nn);
                    if nn>=2
                        for i=1:nn-1
                            diff=obj.buffer{ii,jj}{i+1}{3}{3}-obj.buffer{ii,jj}{i}{3}{3};
                            dt(i)=diff(4)*60*60+diff(5)*60+diff(6);
                        end
                    end
                    st=exprnd(1/obj.mu(ii,jj),1,nn);
                    a = zeros(1,nn);    %arrival time
                    b = zeros(1,nn);    %service time
                    c = zeros(1,nn);    %leaving time
                    a(1) = 0;
                    if nn>=2
                        for i = 2:nn
                            a(i) = a(i-1) + dt(i-1);
                        end
                    end
                    
                    b(1) = 0;
                    c(1) = b(1) + st(1);
                    if nn>=2
                        for i = 2:nn
                            %new customer arrives before last one leave
                            if(a(i) <= c(i-1))
                                b(i) = c(i-1);
                            %when new one comes, the waiting queue is empty
                            else
                                b(i) = a(i);
                            end
                            %update current one leaving time
                            c(i) = b(i) + st(i);
                        end
                    end
                    
                    cost = zeros(1,nn);
                    for i = 1:nn
                        cost(i)=c(i)-a(i);    %sojourn time
                    end
                    obj.sojourn_total(ii,jj) = c(nn);    %total sojourn time
                    obj.busy_ratio(ii,jj) = sum(st)/obj.sojourn_total(ii,jj); %busy time probability
                    obj.sojourn_mean(ii,jj) = sum(cost)/nn; %averave sojourn time
                    for kk=1:nn
                        diff=obj.buffer{ii,jj}{kk}{3}{3}-obj.buffer{ii,jj}{kk}{3}{1};
                        if obj.buffer{ii,jj}{kk}{4}<=obj.cache_threshold
                            total_time=diff(4)*60*60+diff(5)*60+diff(6)+cost(kk);
                            if obj.debug
                                fprintf('Package %d is cache-hitted on Edge Cloud %d\n', obj.buffer{ii,jj}{kk}{1},obj.id);
                            end
                            obj.cache_hit_num(ii,jj)=obj.cache_hit_num(ii,jj)+1;
                        else
                            total_time=diff(4)*60*60+diff(5)*60+diff(6)+obj.retrieval_time;
                            obj.buffer{ii,jj}{kk}{2}{6}=obj.buffer{ii,jj}{kk}{2}{6}+obj.retrieval_hop;
                            if obj.debug
                                fprintf('Package %d is cache-missed on Edge Cloud %d\n', obj.buffer{ii,jj}{kk}{1},obj.id);
                            end
                        end
                        if total_time>obj.buffer{ii,jj}{kk}{3}{2}
                            if obj.debug
                                fprintf('Package %d is expired when processed by Edge Cloud %d\n', obj.buffer{ii,jj}{kk}{1},obj.id);
                            end
                        else
                            if obj.debug
                                fprintf('Package %d is processed by Edge Cloud %d before deadline\n',obj.buffer{ii,jj}{kk}{1},obj.id);
                            end
                            obj.delay_satis_num(ii,jj)=obj.delay_satis_num(ii,jj)+1;
                        end
                    end
                end
            end
        end  
        
        function [trans_energy,total_energy]=EnergyEstimate(obj)
            computing_energy=0;
            caching_energy=0;
            trans_energy=0;
            
            % energy cost for hardware platform and hosting content
            indicator=zeros(size(obj.buffer)); % indicator for server&VM usage status, 1 for using            
            for ii=1:size(obj.buffer,1)
                for jj=1:size(obj.buffer,2)
                    if isempty(obj.buffer{ii,jj}{1})
                        continue;
                    end
                    indicator(ii,jj)=1;
                end
            end  
            
            server_num=length(find(sum(indicator,2)));
            vm_num=sum(indicator,'all');
            
            if server_num>0
                computing_energy=(server_num*obj.server_ee+vm_num*obj.vm_ee)*obj.time_slot;
                caching_energy=server_num*obj.cache_ee*obj.cache_size*obj.time_slot;
            end
            
            % energy consumption for transmission
            for ii=1:size(obj.buffer,1)
                for jj=1:size(obj.buffer,2)
                    if isempty(obj.buffer{ii,jj}{1})
                        continue;
                    end
                    
                    for nn=1:length(obj.buffer{ii,jj})
                        if isempty(obj.buffer{ii,jj}{nn})
                            break;
                        end
                    end
                    if nn<length(obj.buffer{ii,jj})
                        nn=nn-1;
                    end
                    
                     for kk=1:nn
                         trans_energy=trans_energy+obj.trans_ee*obj.buffer{ii,jj}{kk}{5}*obj.buffer{ii,jj}{kk}{2}{6};
                     end
                end
            end                    
            
            total_energy=computing_energy+caching_energy+trans_energy;
        end
        
    end
    
end

