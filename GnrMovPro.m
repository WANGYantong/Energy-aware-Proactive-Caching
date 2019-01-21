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
%       desire, 'H' means high moving desire, 'M' means mixed mode, i.e.
%       part of users tend to stay, the rest have high moving desire; last bit is optional, 'D'
%       indicates determined direction. opts are combination of these
%       letters, all supported items are 'RL','RH','RHD','RM','CL','CH','CHD'
%
%   Output variables:
%       probability: the probability of mobile users moving to which
%                       access_router

if nargin ~= 3
    error('Error. \n Illegal input number')
end

rng(1);

probability=zeros(NF,NA);

switch opts
    case 'RL'
        for ii=1:NF
            [base,label]=SetBase(NA);
            probability(ii,base)=1;
            if label==1
                probability(ii,base+1)=0.09*rand()+0.01;
                probability(ii,base)=probability(ii,base)-probability(ii,base+1);
            elseif label==3
                probability(ii,base-1)=0.09*rand()+0.01;
                probability(ii,base)=probability(ii,base)-probability(ii,base-1);
            else
                probability(ii,base-1)=0.09*rand()+0.01;
                probability(ii,base+1)=0.09*rand()+0.01;
                probability(ii,base)=probability(ii,base)...
                    -probability(ii,base-1)-probability(ii,base+1);
            end
        end
        
    case 'RH'
        for ii=1:NF
            [base,label]=SetBase(NA);
            probability(ii,base)=1;
            if label==1
                probability(ii,base+1)=0.1*rand()+0.8;
                probability(ii,base)=probability(ii,base)-probability(ii,base+1);
            elseif label==3
                probability(ii,base-1)=0.1*rand()+0.8;
                probability(ii,base)=probability(ii,base)-probability(ii,base-1);
            else
                probability(ii,base-1)=0.05*rand()+0.4;
                probability(ii,base+1)=0.05*rand()+0.4;
                probability(ii,base)=probability(ii,base)...
                    -probability(ii,base-1)-probability(ii,base+1);
            end
        end
        
    case 'RHD'
        for ii=1:NF
            [base,label]=SetBase(NA);
            probability(ii,base)=1;
            if label==1
                probability(ii,base+1)=0.09*rand()+0.01; % pretend base is #(base+1) and move to #(base)
                probability(ii,base)=probability(ii,base)-probability(ii,base+1);
            elseif label==3
                probability(ii,base-1)=0.1*rand()+0.8;
                probability(ii,base)=probability(ii,base)-probability(ii,base-1);
            else
                probability(ii,base-1)=0.1*rand()+0.8;
                probability(ii,base+1)=0.05*rand()+0.01;
                probability(ii,base)=probability(ii,base)...
                    -probability(ii,base-1)-probability(ii,base+1);
            end
        end
        
    case 'RM'
        for ii=1:NF
            [base,label]=SetBase(NA);
            probability(ii,base)=1;
            if rand()>=0.5 % high moving desire
                if label==1
                    probability(ii,base+1)=0.1*rand()+0.8;
                    probability(ii,base)=probability(ii,base)-probability(ii,base+1);
                elseif label==3
                    probability(ii,base-1)=0.1*rand()+0.8;
                    probability(ii,base)=probability(ii,base)-probability(ii,base-1);
                else
                    probability(ii,base-1)=0.05*rand()+0.4;
                    probability(ii,base+1)=0.05*rand()+0.4;
                    probability(ii,base)=probability(ii,base)...
                        -probability(ii,base-1)-probability(ii,base+1);
                end
            else
                if label==1
                    probability(ii,base+1)=0.09*rand()+0.01;
                    probability(ii,base)=probability(ii,base)-probability(ii,base+1);
                elseif label==3
                    probability(ii,base-1)=0.09*rand()+0.01;
                    probability(ii,base)=probability(ii,base)-probability(ii,base-1);
                else
                    probability(ii,base-1)=0.09*rand()+0.01;
                    probability(ii,base+1)=0.09*rand()+0.01;
                    probability(ii,base)=probability(ii,base)...
                        -probability(ii,base-1)-probability(ii,base+1);
                end
            end
        end
        
    case 'CL'
        [base,label]=SetBase(NA);
        for ii=1:NF
            probability(ii,base)=1;
            if label==1
                probability(ii,base+1)=0.09*rand()+0.01;
                probability(ii,base)=probability(ii,base)-probability(ii,base+1);
            elseif label==3
                probability(ii,base-1)=0.09*rand()+0.01;
                probability(ii,base)=probability(ii,base)-probability(ii,base-1);
            else
                probability(ii,base-1)=0.09*rand()+0.01;
                probability(ii,base+1)=0.09*rand()+0.01;
                probability(ii,base)=probability(ii,base)...
                    -probability(ii,base-1)-probability(ii,base+1);
            end
        end
        
    case 'CH'
        [base,label]=SetBase(NA);
        for ii=1:NF
            probability(ii,base)=1;
            if label==1
                probability(ii,base+1)=0.1*rand()+0.8;
                probability(ii,base)=probability(ii,base)-probability(ii,base+1);
            elseif label==3
                probability(ii,base-1)=0.1*rand()+0.8;
                probability(ii,base)=probability(ii,base)-probability(ii,base-1);
            else
                probability(ii,base-1)=0.05*rand()+0.4;
                probability(ii,base+1)=0.05*rand()+0.4;
                probability(ii,base)=probability(ii,base)...
                    -probability(ii,base-1)-probability(ii,base+1);
            end
        end
        
    case 'CHD'
        [base,label]=SetBase(NA);
        for ii=1:NF
            probability(ii,base)=1;
            if label==1
                probability(ii,base+1)=0.09*rand()+0.01; % pretend base is #(base+1) and move to #(base)
                probability(ii,base)=probability(ii,base)-probability(ii,base+1);
            elseif label==3
                probability(ii,base-1)=0.1*rand()+0.8;
                probability(ii,base)=probability(ii,base)-probability(ii,base-1);
            else
                probability(ii,base-1)=0.1*rand()+0.8;
                probability(ii,base+1)=0.05*rand()+0.01;
                probability(ii,base)=probability(ii,base)...
                    -probability(ii,base-1)-probability(ii,base+1);
            end
        end
        
    otherwise
        error('Error. \n Illegal parameter: opts')
        
end

end

function [base,label]=SetBase(NA)

base=randi([1,NA]);

switch base
    case 1
        label=1;
    case NA
        label=3;
    otherwise
        label=2;
end

end
