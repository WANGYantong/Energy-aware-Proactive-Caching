function probability = GnrMovPro(NF,NA,opts)
%GnrMovPro return the probability of mobile users movement
%
%   Input variables:
%
%       NF: number of flows
%
%       NA: number of access router
%
%       opts: 3-bit options for different scenarios-first bit: 'R' means random start point,
%       'C' means fixed start point; second bit: 'L' means low moving
%       desire, 'H' means high moving desire; last bit is optional, 'D'
%       indicates determined direction. opts are combination of these
%       letters, all supported items are 'RL','RH','RHD','CL','CH','CHD' 
%
%   Output variables:
%       probability: the probability of mobile users moving to which
%                       access_router

if nargin ~= 3
	error('Error. \n Illegal input number')
end

probability=zeros(NF,NA);

switch opts
    case 'RL'
        
    case 'RH'
        
    case 'RHD'
        
    case 'CL'
        base=FindBase(NA);
        
    case 'CH'
        base=FindBase(NA);
        
    case 'CHD'
        base=FindBase(NA);
        
    otherwise 
        
end

for ii=1:NF_TOTAL
    probability(ii,length(AccessRouter))=1;
    for jj=1:length(AccessRouter)-1
        probability(ii,jj)=rand()/(length(AccessRouter)-1);
        probability(ii,length(AccessRouter))=...
            probability(ii,length(AccessRouter))-probability(ii,jj);
    end
    index=randi(length(AccessRouter));
    buffer=probability(ii,length(AccessRouter));
    probability(ii,length(AccessRouter))=probability(ii,index);
    probability(ii,index)=buffer;
end

end


function base=FindBase(NA)

base=randi([1,NA]);

end

function pro


end
