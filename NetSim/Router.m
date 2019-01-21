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
            obj.forward=routing(router_setting.path);
        end
        
        function table=routing(path)
            table=zeros(size(path,2),2);
            % next?
        end
        
%         function send
%             
%         function receive

    end
end

