classdef EdgeCloudClass < RouterClass
    %EDGE_CLOUD Summary of this class goes here
    
    properties
%         buffer;           % waiting list for coming request
        mu;               % ability to deal with request, measured by processing time
    end
    
%     properties (SetObservable)
%         lengthBuffer=0;
%     end
    
    methods
        function obj = EdgeCloudClass(ec_setting)
            %EDGE_CLOUD Construct an instance of this class
            obj@RouterClass(ec_setting);
%             obj.buffer=cell(ec_setting.size);
            obj.mu=ec_setting.mu;
%             obj.attachListener;
        end
        
%         function attachListener(obj)
%             addlistener(obj, 'lengthBuffer', 'PostSet', @EdgeCloudClass);
%         end
        
        function sendingHandle(obj,~,eventData)
            if obj.id==eventData.Package{2}{2}  % the package is send to this router
                if obj.id==eventData.Package{2}{3} % this router is the final destination
                    fprintf('Package %d is received by Edge Cloud %d\n',eventData.Package{1},obj.id);
                    obj.processRequest(eventData);
                else                          % relay the package
                    fprintf('Package %d is relayed by Edge Cloud %d\n',eventData.Package{1},obj.id);
                    pause(1);             % pretend processing delay+propogation delay
                    index=find(obj.forward(:,2)==eventData.Package{2}{3});
                    eventData.Package{2}{2}=obj.forward(index,1);            % update the next hop destination according to forward map
                    eventData.Package{3}{3}=clock;            % update the time stamp
                    notify(obj,'sending',DeliveryPackageClass(eventData.Package));
                end
            end
        end
        
        function processRequest(obj,eventData)
            pause(obj.processTime);
            eventData.Package{3}{3}=clock; 
            diff=eventData.Package{3}{3}-eventData.Package{3}{1};
            totalTime=diff(4)*60*60+diff(5)*60+diff(6);
            if totalTime>eventData.Package{3}{2}
                fprintf('Package %d is expired when processed by Edge Cloud %d\n', eventData.Package{1},obj.id);
            else
                fprintf('Package %d is processed by Edge Cloud %d before deadline\n', eventData.Package{1},obj.id);
            end
        end
        
        function time=processTime(obj)
            time=exprnd(1/obj.mu);
        end      
        
    end
end

