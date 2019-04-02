function result=NEC(flow,data,para,opts)
% opts.prior=1 - has prior knowledge of user movement;
% opts.prior=0 - no prior knowledge

if nargin<3
    error('Not Enough Input Arguements!');
end

if nargin<4
    opts.prior=1;
end

NF=length(flow);

data.S_k=data.S_k(1:NF);
data.delay_k=data.delay_k(1:NF);
data.probability_ka=data.probability_ka(1:NF,:);
data.T_k=data.T_k(1:NF);

result.sol.pi=zeros(NF,length(para.EdgeCloud),data.N_e,data.N_es);

if opts.prior==1
    judge_vector=sum(data.probability_ka*data.N);
else
    judge_vector=sum(data.N);
end
[~,II]=sort(judge_vector);

pointer=1;
ec_index=II(pointer);
server_index=1;
vm_index=1;

indicator=data.mu_esv*data.DeltaT-data.DeltaT/min(data.delay_k);

for ii=1:NF
    if indicator(ec_index, server_index, vm_index)>1
        result.sol.pi(ii,ec_index,server_index,vm_index)=1;
        indicator(ec_index, server_index, vm_index)=...
            indicator(ec_index, server_index, vm_index)-1;
    else
        if vm_index<data.N_es
            vm_index=vm_index+1;
        elseif server_index<data.N_e
            server_index=server_index+1;
            vm_index=1;
        else
            pointer=pointer+1;
            ec_index=II(pointer);
            server_index=1;
            vm_index=1;
        end
        result.sol.pi(ii,ec_index,server_index,vm_index)=1;
        indicator(ec_index, server_index, vm_index)=...
            indicator(ec_index, server_index, vm_index)-1;
    end    
end

end