classdef RouterClass < handle
    % Original network router in ICN-based RAN
    
    properties
        id;                  % identification of router
        connection;          % list for recording connected 
        forward;             % forward table
        time;                  % processing+propagation time
        name_table;
        
        debug=1;     % 0 disable screen printf
    end
    
    events
        sending
    end
    
    methods
        
        function obj = RouterClass(router_setting)
            %ROUTER Construct an instance of this class
            obj.id=router_setting.id;
            obj.connection=router_setting.connection;
            obj.forward=obj.Routing(router_setting.path, router_setting.ec);
            obj.name_table=router_setting.name_table;
            obj.time=router_setting.time;
        end
        
        function SetListener(obj,listening_list)
            addlistener(listening_list,'sending',@(src,data)SendingHandle(obj,src,data));
        end
        
        function table=Routing(obj,path,ec)
            table=zeros(length(ec),2);
            table(:,2)=ec;
            for ii=1:size(path,2)
                for jj=1:size(path,1)
                    if find(path{jj,ii}==ec(ii))
                        index= find(path{jj,ii}==obj.id);
                        if isempty(index) || index==length(path{jj,ii})
                            continue;
                        end
                        table(ii,1)=path{jj,ii}(index+1);
                    end
                end
            end                
        end
        
        function SendingHandle(obj,~,eventData)
            if obj.id==eventData.package{2}{2}  % the package is send to this router                
                if obj.id==eventData.package{2}{3} % this router is the final destination
                    if obj.debug
                        fprintf('Package %d is received by %s\n',eventData.package{1},obj.name_table{obj.id});
                    end
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
        
    end
end

