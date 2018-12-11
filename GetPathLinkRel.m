function beta = GetPathLinkRel(graph,direction,path,counter_a,counter_e)
%GETPATHLINKREL generate a binary matrix beta to show the ownership
%between paths and links
%
%   Input variables:
%     
%        graph:  the graph
%
%        direction: indicate graph is 'directed' or 'undirected'
%
%        path: the possible route of the graph, cell array
%
%        counter_a: the number of access_router in graph
%
%        counter_e: the number of edge_cloud in graph
%
% 	Output variables:
%
%        beta: if beta(i,j,k)=1, it means the path(j,k) go across link(i)
%

if nargin ~= 5
    error('Error. \n Illegal input number')
end

[s,t] = findedge(graph);

beta = zeros(length(s),counter_a,counter_e);
arcs = [s,t]; 

for ii = 1:counter_a
    for jj = 1:counter_e
        for kk = 1:length(path{ii,jj})-1
            link=FindLink(path{ii,jj}(kk:kk+1),arcs,direction);
            if link
                beta(link,ii,jj) = 1;
            end
        end
    end
end

end

function link = FindLink(path,arcs,direction)

link = 0;
if direction == "directed"
    for ii = 1:length(arcs)
        if arcs(ii,1) == path(1) && arcs(ii,2) == path(2)
            link = ii;
            break;
        end
    end
else
    for ii = 1:length(arcs)
        if (arcs(ii,1) == path(1) && arcs(ii,2) == path(2))...
                || (arcs(ii,1) == path(2) && arcs(ii,2) == path(1))           
            link = ii;
            break;
        end
    end
end

end
