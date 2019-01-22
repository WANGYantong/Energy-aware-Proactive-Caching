classdef Router
    % Original network router in ICN-based RAN
    
    properties
        id;                  % identification of router
        connection;          % list for recording connected 
        forward;             % forward map
    end
    
    methods
        
        function obj = Router(router_setting)
            %ROUTER Construct an instance of this class
            obj.id=router_setting.id;
            obj.connection=router_setting.connection;
            obj.forward=obj.routing(router_setting.path, router_setting.ec);
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
        
%         function send
%             
%         function receive

    end
end

