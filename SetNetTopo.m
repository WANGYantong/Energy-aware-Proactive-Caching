function [G,EdgeCloud,NormalRouter,AccessRouter,vertice_name] = SetNetTopo()

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

highlight(h,GW,'NodeColor','g','Marker','p','MarkerSize',18);
highlight(h,EdgeCloud,'Marker','d','MarkerSize',16);
highlight(h,NormalRouter,'Marker','o','MarkerSize',16);
highlight(h,AccessRouter,'NodeColor','b');

h.XData=[4,1,5,2,5,3,7,4,6,3];
h.YData=[4,1,1,2,3,1,1,2,2,3];

title('Network Topology');

end

