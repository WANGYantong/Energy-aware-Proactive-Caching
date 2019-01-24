classdef (ConstructOnLoad) DeliveryPackageClass < event.EventData
    
    properties
        Package = []
    end
    
    methods
        function eventData = SpecialEventDataClass(data)
            eventData.Package = data;
        end
    end
    
end

