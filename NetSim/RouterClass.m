classdef RouterClass < handle
    % Original network router in ICN-based RAN
    
    properties
        id;                  % identification of router
        connection;          % list for recording connected 
        forward;             % forward map
    end
    
    events
        sending
    end
    
    methods
        
        function obj = RouterClass(router_setting)
            %ROUTER Construct an instance of this class
            obj.id=router_setting.id;
            obj.connection=router_setting.connection;
            obj.forward=obj.routing(router_setting.path, router_setting.ec);          
        end
        
        function setlistener(obj,listening_list)
            addlistener(listening_list,'sending',@(src,data)sendingHandle(obj,src,data));
        end
        
        function table=routing(obj,path,ec)
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
        
        function sendingHandle(obj,~,eventData)
            if obj.id==eventData.Package{2}{2}  % the package is send to this router                
                if obj.id==eventData.Package{2}{3} % this router is the final destination
                    fprintf('Package %d is received by Router %d\n',eventData.Package{1},obj.id);
                else                          % relay the package                   
                    fprintf('Package %d is relayed by Router %d\n',eventData.Package{1},obj.id);
                    pause(0.1);             % pretend processing delay+propogation delay
                    index=find(obj.forward(:,2)==eventData.Package{2}{3});
                    eventData.Package{2}{2}=obj.forward(index,1);            % update the next hop destination according to forward map
                    eventData.Package{3}{3}=clock;            % update the time stamp                    
                    notify(obj,'sending',DeliveryPackageClass(eventData.Package));
                end
            end
        end
        
    end
end

