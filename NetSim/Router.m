classdef Router
    % Original network router in ICN-based RAN
    
    properties
        id;
        posX;
        posY;
        
    end
    
    methods
        function obj = Router(inputArg1,inputArg2)
            %ROUTER Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

