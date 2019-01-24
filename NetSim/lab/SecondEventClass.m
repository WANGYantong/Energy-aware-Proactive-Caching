classdef SecondEventClass < handle
    %SECONDEVENTCLASS Summary of this class goes here
    
    %     properties
    %         Pro1=0;
    %     end
    
    events
        Overflow
    end
    
    methods
        function obj = SecondEventClass(sec)  % sec could be an array
            addlistener(sec,'Overflow',@(src, data)overflowHandle(obj,src,data));
        end
        
        function overflowHandle(obj,eventSrc, eventData)
            disp('The value of Prop1 is overflowing!')
            disp(['Its value was: ' num2str(eventData.OrgValue)])
            disp(['Its current value is: ' num2str(eventSrc.Prop1)])
            if eventSrc.Prop1==13
                eventSrc.Prop1=8888;
                notify(obj, 'Overflow', SpecialEventDataClass(eventSrc));
            end
        end
    end
end

