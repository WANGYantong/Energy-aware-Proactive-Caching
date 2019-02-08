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
                    obj.buffer{ii,jj}=cell(ec_setting.sizeBuffer);
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
                    pause(0.01);             % pretend processing delay+propogation delay
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
                    break;
                end
            end
        end
        
        function processBuffer(obj)
            for ii=1:size(obj.buffer,1)
                for jj=1:size(obj.buffer,2)
                    if isempty(obj.buffer{ii,jj}{1})
                        break;
                    end
                    
                    nn=0;
                    while(1)
                        if isempty(obj.buffer{ii,jj}{nn+1})
                            break;
                        else
                            nn=nn+1;
                        end
                    end
                    
                    dt=zeros(1,nn);
                    if nn>=2
                        for i=1:nn-1
                            diff=obj.buffer{ii,jj}{i+1}{3}{3}-obj.buffer{ii,jj}{i}{3}{3};
                            dt(i)=diff(4)*60*60+diff(5)*60+diff(6);
                        end
                    end
                    st=exprnd(1/obj.mu,1,nn);
                    a = zeros(1,nn);    %arrival time
                    b = zeros(1,nn);    %service time
                    c = zeros(1,nn);    %leaving time
                    a(1) = 0;
                    if nn>=2
                        for i = 2:nn
                            a(i) = a(i-1) + dt(i-1);
                        end
                    end
                    
                    b(1) = 0;
                    c(1) = b(1) + st(1);
                    if nn>=2
                        for i = 2:nn
                            %new customer arrives before last one leave
                            if(a(i) <= c(i-1))
                                b(i) = c(i-1);
                            %when new one comes, the waiting queue is empty
                            else
                                b(i) = a(i);
                            end
                            %update current one leaving time
                            c(i) = b(i) + st(i);
                        end
                    end
                    
                    cost = zeros(1,nn);
                    for i = 1:nn
                        cost(i)=c(i)-a(i);    %sojourn time
                    end
%                     T = c(nn);    %total sojourn time
%                     p = sum(st)/T; %busy time probability
%                     ave_t = sum(cost)/n; %averave sojourn time
                    for kk=1:nn
                        diff=obj.buffer{ii,jj}{kk}{3}{3}-obj.buffer{ii,jj}{kk}{3}{1};
                        if obj.buffer{ii,jj}{kk}{4}<=50
                            totalTime=diff(4)*60*60+diff(5)*60+diff(6)+cost(kk);
                            fprintf('Package %d is cache-hitted on Edge Cloud %d\n', obj.buffer{ii,jj}{kk}{1},obj.id);
                        else
                            totalTime=diff(4)*60*60+diff(5)*60+diff(6)+0.5;
                            fprintf('Package %d is cache-missed on Edge Cloud %d\n', obj.buffer{ii,jj}{kk}{1},obj.id);
                        end
                        if totalTime>obj.buffer{ii,jj}{kk}{3}{2}
                            fprintf('Package %d is expired when processed by Edge Cloud %d\n', obj.buffer{ii,jj}{kk}{1},obj.id);
                        else
                            fprintf('Package %d is processed by Edge Cloud %d before deadline\n',obj.buffer{ii,jj}{kk}{1},obj.id);
                        end
                    end
                end
            end
        end    
        
    end
end

