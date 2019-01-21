classdef Router
    % Original network router in ICN-based RAN
    
    properties
        id;                  % identification of router
%         buffer;           % waiting list for coming request
        connection;   % list for recording connected 
        forward;        % forward map
%         mu;               % ability to deal with request, measured by processing time
    end
    
    methods
        function obj = Router(router_setting)
            %ROUTER Construct an instance of this class
            %   Detailed explanation goes here
            obj.id=router_setting.id;
%             obj.buffer=cell(router_setting.size);
            obj.connection=router_setting.connection;
        end
        
%         function send
%             
%         function receive

    end
end

