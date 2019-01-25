classdef SimpleEventClass < handle
    
    properties
        id;
        Prop1 = 0;
    end
    
    events
        Overflow;
    end
    
    methods
        function obj=SimpleEventClass(id)
            obj.id=id;
        end
        function set.Prop1(obj,value)
            orgvalue = obj.Prop1;
            obj.Prop1 = value;
            if obj.Prop1>=10 && obj.Prop1 <15
                % Trigger the event using custom event data
                notify(obj,'Overflow',SpecialEventDataClass(orgvalue));
            end
        end
    end
    
end
