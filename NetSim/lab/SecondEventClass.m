classdef SecondEventClass < handle
    %SECONDEVENTCLASS Summary of this class goes here
    
    properties
        id;
        Prop1=0;
    end
    
    events
        Overflow
    end
    
    methods
        function obj = SecondEventClass(sec,id)  % sec could be an array
            addlistener(sec,'Overflow',@(src, data)overflowHandle(obj,src,data));
            obj.id=id;
        end
        
        function overflowHandle(obj,eventSrc, eventData)
            disp(['The value of Prop1 is overflowing! Listener: ' num2str(obj.id)])
            disp(['Its value was: ' num2str(eventData.OrgValue)])
            disp(['Its current value is: ' num2str(eventSrc.Prop1)])
            if eventSrc.Prop1==13
                eventSrc.Prop1=22;
                notify(obj, 'Overflow', SpecialEventDataClass(eventSrc.Prop1));
            end
        end
    end
end

