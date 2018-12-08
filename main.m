clear
clc


%% Generate Network
[G,EdgeCloud,NormalRouter,AccessRouter,vertice_name]=SetNetTopo();
N=length(vertice_names);
for v=1:N
    eval([vertice_names{v},'=',num2str(v),';']);
end

%% Construct Network Flow
flow=20;

%% 

