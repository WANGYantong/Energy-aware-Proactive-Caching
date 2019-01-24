classdef (ConstructOnLoad) SpecialEventDataClass < event.EventData
    %SPECIALEVENTDATACLASS Summary of this class goes here
    
    properties
        OrgValue = 0
    end
    
   methods
      function eventData = SpecialEventDataClass(value)
         eventData.OrgValue = value;
      end
   end
   
end

