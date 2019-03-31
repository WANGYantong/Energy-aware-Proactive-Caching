function result = RDM(flow,data,para,opts)
% opts.method=1 : centrality-based on path caching, source: cache "less for
%                             more" in Information-centric networks
% opts.method=0 : random on path caching, source: on content-centric router
%                            design and implications (default)

if nargin<3
    error('Not enough input parameters!');
end

if nargin<4
    opts.method=0;
end

NF=length(flow);

data.S_k=data.S_k(1:NF);
data.delay_k=data.delay_k(1:NF);
data.probability_ka=data.probability_ka(1:NF,:);
data.T_k=data.T_k(1:NF);

GW=para.NormalRouter(1); % the first element in NormalRouter is GateWay in main.m
path_RDM=cell(size(para.AccessRouter));
for ii=1:length(para.AccessRouter)
    path_RDM{ii}=shortestpath(para.graph, para.AccessRouter(ii), GW);
end

if opts.method==0
    indicator=zeros(size(para.EdgeCloud));
    for ii=1:length(para.AccessRouter)
        candidates=intersect(find(path_RDM{ii}>=para.EdgeCloud(1)), ...
            find(path_RDM{ii}<=para.EdgeCloud(end))); % when edgeclouds are coded continuesly
        if isempty(intersect(path_RDM{ii}(candidates),para.EdgeCloud(find(indicator))))
            index=randperm(numel(candidates));
            winner=path_RDM{ii}(candidates(index(1)));
            indicator(winner==para.EdgeCloud)=1;
        else
            continue;
        end
    end
else
    
end

end



