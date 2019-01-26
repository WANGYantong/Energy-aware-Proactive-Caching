classdef EdgeCloudClass < RouterClass
    %EDGE_CLOUD Summary of this class goes here
    
    properties
        buffer;           % waiting list for coming request
        mu;               % ability to deal with request, measured by processing time
    end
    
    methods
        function obj = EdgeCloudClass(ec_setting)
            %EDGE_CLOUD Construct an instance of this class
            obj@RouterClass(ec_setting);
            obj.buffer=cell(ec_setting.size);
            obj.mu=ec_setting.mu;
        end
        

    end
end

