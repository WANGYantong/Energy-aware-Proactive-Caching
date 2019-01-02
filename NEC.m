function result=NEC(flow,data,para)

NF=length(flow);

data.S_k=data.S_k(1:NF);
data.delay_k=data.delay_k(1:NF);
data.probability_ka=data.probability_ka(1:NF,:);
data.T_k=data.T_k(1:NF);

end