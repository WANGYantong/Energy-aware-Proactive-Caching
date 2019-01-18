function [G,EdgeCloud,NormalRouter,AccessRouter,vertice_name] = SetNetTopo(opts)
% SETNETTOPO Generate different network typology for simulation
%
% Input Variable:
%         
%         opts: the input setting for the network architecture, where 1 for
%         sparse tree topology with 15 nodes; 2 for dense tree with 15
%         nodes; and default for a hetnet with 10 nodes.
%
% Output Variables:
%         
%         G: Generated graph structure
%
%         EdgeCloud: A set for mobile edge clouds/clusters of content
%         routers
%
%         NormalRouter: The set for traditional routers
%
%         AccessRouter: The set for access routers
%
%         vertice_name: the cell array of node names


if nargin==0
    opts=3;
end

switch opts
    
    case 1
        
        vertice_name={'GW','EC1','EC2','EC3','EC4','EC5','EC6','R1','R2','R3','R4','R5','R6','R7','R8'};
        
        numNode=length(vertice_name);
        
        for v=1:numNode
            eval([vertice_name{v},'=',num2str(v),';']);
        end
        
        EdgeCloud=EC1:EC6;
        NormalRouter=R1:R8;
        AccessRouter=NormalRouter;
        
        s=repmat(GW:EC6,2,1);
        s=reshape(s,1,[]);
        t=EC1:R8;
        
        weight=ones(size(s));
        
        figure(1);
        
        G=graph(s,t,weight,vertice_name);
        h=plot(G,'NodeLabel',G.Nodes.Name);
        
        highlight(h,GW,'NodeColor','g','Marker','p','MarkerSize',16);
        highlight(h,EdgeCloud,'Marker','d','MarkerSize',12);
        highlight(h,NormalRouter,'Marker','o','MarkerSize',12);
        highlight(h,AccessRouter,'NodeColor','b');
        
        h.XData=[8,4,12,2:4:14,1:2:15];
        h.YData=[4,3*ones(1,2),2*ones(1,4),ones(1,8)];
        
        title('Network Topology');
        
    case 2
        
        vertice_name={'GW','EC1','EC2','EC3','EC4','EC5','EC6','R1','R2','R3','R4','R5','R6','R7','R8'};
        
        numNode=length(vertice_name);
        
        for v=1:numNode
            eval([vertice_name{v},'=',num2str(v),';']);
        end
        
        EdgeCloud=EC1:EC6;
        NormalRouter=R1:R8;
        AccessRouter=NormalRouter;
        
        s=repmat(GW:EC6,2,1);
        s=reshape(s,1,[]);
        s=[s,EC1,EC3:EC5,R1:R7];
        t=[EC1:R8,EC2,EC4:EC6,R2:R8];
        
        weight=ones(size(s));
        
        figure(1);
        
        G=graph(s,t,weight,vertice_name);
        h=plot(G,'NodeLabel',G.Nodes.Name);
        
        highlight(h,GW,'NodeColor','g','Marker','p','MarkerSize',16);
        highlight(h,EdgeCloud,'Marker','d','MarkerSize',12);
        highlight(h,NormalRouter,'Marker','o','MarkerSize',12);
        highlight(h,AccessRouter,'NodeColor','b');
        
        h.XData=[8,4,12,2:4:14,1:2:15];
        h.YData=[4,3*ones(1,2),2*ones(1,4),ones(1,8)];
        
        title('Network Topology');
        
    otherwise
        
        vertice_name={'GW','EC1','EC2','EC3','EC4','R1','R2','R3','R4','R5'};
        
        numNode=length(vertice_name);
        
        for v=1:numNode
            eval([vertice_name{v},'=',num2str(v),';']);
        end
        
        EdgeCloud=EC1:EC4;
        NormalRouter=R1:R5;
        AccessRouter=[EC1,R1,EC2,R2];
        
        s=[GW,GW,R5,R5,EC4,EC4,EC3,EC3,R3,R3,R4,EC2];
        t=[R5,EC4,EC3,R3,R3,R4,EC1,R1,R1,EC2,R2,R2];
        
        weight=ones(size(s));
        
        figure(1);
        
        G=graph(s,t,weight,vertice_name);
        h=plot(G,'NodeLabel',G.Nodes.Name);
        
        highlight(h,GW,'NodeColor','g','Marker','p','MarkerSize',16);
        highlight(h,EdgeCloud,'Marker','d','MarkerSize',12);
        highlight(h,NormalRouter,'Marker','o','MarkerSize',12);
        highlight(h,AccessRouter,'NodeColor','b');
        
        h.XData=[4,1,5,2,5,3,7,4,6,3];
        h.YData=[4,1,1,2,3,1,1,2,2,3];
        
        title('Network Topology');
        
end

end

