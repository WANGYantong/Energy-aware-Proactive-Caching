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
            obj.buffer=cell(ec_setting.numServer,ec_setting.numVM);
            for ii=1:ec_setting.numServer
                for jj=1:ec_setting.numVM
                    obj.buffer=cell(ec_setting.sizeBuffer);
                end
            end
            obj.mu=ec_setting.mu;
        end
        
        function sendingHandle(obj,~,eventData)
            if obj.id==eventData.Package{2}{2}  % the package is send to this router
                if obj.id==eventData.Package{2}{3} % this router is the final destination
                    fprintf('Package %d is received by Edge Cloud %d\n',eventData.Package{1},obj.id);
                    obj.putInBuffer(eventData.Package);
                else                          % relay the package
                    fprintf('Package %d is relayed by Edge Cloud %d\n',eventData.Package{1},obj.id);
                    pause(0.1);             % pretend processing delay+propogation delay
                    index=find(obj.forward(:,2)==eventData.Package{2}{3});
                    eventData.Package{2}{2}=obj.forward(index,1);            % update the next hop destination according to forward map
                    eventData.Package{3}{3}=clock;            % update the time stamp
                    notify(obj,'sending',DeliveryPackageClass(eventData.Package));
                end
            end
        end
        
        function putInBuffer(obj,Package)
            serverIdx=Package{2}{4};
            vmIdx=Package{2}{5};        %locate the buffer
            Package{3}{3}=clock;         %update time stamp 
            for ii=1:length(obj.buffer{serverIdx,vmIdx})
                if isempty(obj.buffer{serverIdx,vmIdx}{ii})
                    obj.buffer{serverIdx,vmIdx}{ii}=Package;
                end
            end
        end
        
        function processBuffer(obj)
            for ii=1:size(obj.buffer,1)
                for jj=1:size(obj.buffer,2)
                    for kk=1:length(obj.buffer{ii,jj})
                        if isempty(obj.buffer{ii,jj}{kk})
                            break;
                        end
                        obj.buffer{ii,jj}{kk}=obj.processPackage(obj.buffer{ii,jj}{kk});
                        diff=obj.buffer{ii,jj}{kk}.Package{3}{3}-obj.buffer{ii,jj}{kk}.Package{3}{1};
                        totalTime=diff(4)*60*60+diff(5)*60+diff(6);
                        if totalTime>obj.buffer{ii,jj}{kk}.Package{3}{2}
                            fprintf('Package %d is expired when processed by Edge Cloud %d\n', eventData.Package{1},obj.id);
                        else
                            fprintf('Package %d is processed by Edge Cloud %d before deadline\n', eventData.Package{1},obj.id);
                        end
                    end
                end
            end
        end
        
        function bufferAft=processPackage(obj, bufferPre)
            bufferAft=bufferPre;
        end      
        
    end
end

