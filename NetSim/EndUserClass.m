classdef EndUserClass < handle
    %END_USER Summary of this class goes here
    
    properties
        id;                     % user identification
        position;           % the access router user connect currently
        destination;      % the access router user may move to after handover
        interest;            % request content
        born_time=0;   % request generation moment
        delay;               % delay tolerance
        ec;                    % retrieved edge cloud;
        server;              % the server in retrieved edge cloud;
        vm;                   % the vm for processing request
        content_size;    % the size for requested content(MB)
    end
    
    events
        sending
    end
    
    methods
        
        function obj = EndUserClass(user_setting)
            %END_USER Construct an instance of this class
            obj.id = user_setting.id;
            obj.position = obj.Location(user_setting.probability, user_setting.access_router);
            obj.destination = obj.Moving(user_setting.probability, user_setting.access_router);
            obj.interest = user_setting.interest;
            obj.delay = user_setting.delay;
            if user_setting.opt==0
                obj.ec = user_setting.ec;
                obj.server = user_setting.server;
                obj.vm = user_setting.vm;
            else
                obj.server=mod(user_setting.id,user_setting.server)+1;
                obj.vm=mod(floor(user_setting.id/user_setting.server),user_setting.VM)+1;
                path=user_setting.path{user_setting.AccessRouter==obj.destination};
                candidates=intersect(path, user_setting.EdgeCloud(find(user_setting.assign)));
                obj.ec=candidates(1);
            end
            obj.content_size=user_setting.content_size;
        end
        
        function pos=Location(obj, prob, ar)
            res=find(prob);
            if length(res)==3
                pos=ar(res(2));
            elseif length(res)==2
                if res(1)==1
                    pos=ar(1);
                else
                    pos=ar(end);
                end
            end
        end
        
        function des=Moving(obj, prob, ar)
            desire=rand();
            if obj.position==ar(1)
                if desire<=prob(1)
                    des=ar(1);
                else
                    des=ar(2);
                end
            elseif obj.position==ar(end)
                if desire<=prob(end-1)
                    des=ar(end-1);
                else
                    des=ar(end);
                end
            else
                pos=find(prob);
                if desire<=prob(pos(1))
                    des=ar(pos(1));
                elseif desire<=prob(pos(1))+prob(pos(2))
                    des=ar(pos(2));
                else
                    des=ar(pos(3));
                end
            end
        end
        
        function Produce(obj)
            obj.born_time=clock;
            package={obj.id,...
                {obj.destination, obj.destination, obj.ec, obj.server, obj.vm, 0}, ... % the second destination means next hop
                {obj.born_time, obj.delay, obj.born_time},... % the second born_time represents current time stamp
                obj.interest, obj.content_size};  
            notify(obj,'sending',DeliveryPackageClass(package));
        end
               
    end
    
end
