function  result=MILP(flow,data,para,initial_point)

if nargin==3
    initial_point=[];
end

%% parameter tailor
NF=length(flow);

data.S_k=data.S_k(1:NF);
data.delay_k=data.delay_k(1:NF);
data.probability_ka=data.probability_ka(1:NF,:);
data.T_k=data.T_k(1:NF);

%% decision variable
x=optimvar('x',length(para.EdgeCloud),data.N_e,data.N_es,'Type','integer',...
    'LowerBound',0,'UpperBound',1);
y=optimvar('y',length(para.EdgeCloud),data.N_e,'Type','integer',...
    'LowerBound',0,'UpperBound',1);
pi=optimvar('pi',NF,length(para.EdgeCloud),data.N_e,data.N_es,'Type','integer',...
    'LowerBound',0,'UpperBound',1);
z=optimvar('z',NF,length(para.graph.Edges.Weight),'Type','integer',...
    'LowerBound',0,'UpperBound',1);
psi=optimvar('psi',NF,length(para.AccessRouter),length(para.EdgeCloud),'Type','integer',...
    'LowerBound',0,'UpperBound',1);

omega=optimvar('omega',size(x),'LowerBound',0);
phi=optimvar('phi',size(pi),'LowerBound',0);

%% constraints
y_x=repmat(y,[1,1,data.N_es]);
open_constr1=x<=y_x;

[m,n,l]=size(x);
x_pi=reshape(x,1,m*n*l);
x_pi=repmat(x_pi,[NF,1]);
x_pi=reshape(x_pi,NF,m,n,l);
open_constr2=pi<=x_pi;

route_constr=sum(sum(sum(pi,4),3),2)==1;

queue_constr=squeeze(sum(pi,1))<=data.mu_esv;

M=1000;
phi_constr1=phi<=M*pi;
[m,n,l]=size(omega);
omega_pi=reshape(omega,1,m*n*l);
omega_pi=repmat(omega_pi,[NF,1]);
omega_pi=reshape(omega_pi,NF,m,n,l);
phi_constr2=phi<=omega_pi;
phi_constr3=phi>=M*(pi-1)+omega_pi;

linear_constr=data.mu_esv.*omega-squeeze(sum(phi,1))==1;

delay_constr=sum(sum(sum(phi,4),3),2)<=data.delay_k';

link_constr=data.T_k*z<=data.B_l';

pi_mid=squeeze(sum(sum(pi,4),3));
pro_psi=repmat(data.probability_ka,[1,1,length(para.EdgeCloud)]);
pi_psi=repmat(pi_mid,[length(para.AccessRouter),1,1]);
pi_psi=reshape(pi_psi,NF,length(para.AccessRouter),length(para.EdgeCloud));
psi_constr1=psi<=M*pro_psi.*pi_psi;
psi_constr2=psi>=pro_psi.*pi_psi;

[m,n,l]=size(data.beta);
beta_z=reshape(data.beta,1,m*n*l);
beta_z=repmat(beta_z,[NF,1]);
beta_z=reshape(beta_z,NF,m,n,l);
psi_z=repmat(psi,[size(data.beta,1),1,1,1]);
psi_z=reshape(psi_z,NF,size(data.beta,1),length(para.AccessRouter),length(para.EdgeCloud));
z_constr1=z<=sum(sum(beta_z.*psi_z,4),3);
z_constr2=M*z>=sum(sum(beta_z.*psi_z,4),3);

%% objective function
EC=(sum(sum((data.U_es+data.W_C*data.SC).*y))+sum(sum(sum(data.U_esv.*x))))*data.DeltaT;

pi_tem=squeeze(sum(pi_mid*data.N'.*data.probability_ka,2));
ET=sum(data.S_k'.*pi_tem)*data.W_T*data.R+...
    sum(sum(data.probability_ka,2).*data.S_k')*data.W_T*data.M*(1-data.R);

%% Optimization Problem

Energy=optimproblem;

Energy.Objective=EC+ET;

Energy.Constraints.open_constr1=open_constr1;
Energy.Constraints.open_constr2=open_constr2;
Energy.Constraints.route_constr=route_constr;
Energy.Constraints.queue_constr=queue_constr;
Energy.Constraints.phi_constr1=phi_constr1;
Energy.Constraints.phi_constr2=phi_constr2;
Energy.Constraints.phi_constr3=phi_constr3;
Energy.Constraints.linear_constr=linear_constr;
Energy.Constraints.delay_constr=delay_constr;
Energy.Constraints.link_constr=link_constr;
Energy.Constraints.psi_constr1=psi_constr1;
Energy.Constraints.psi_constr2=psi_constr2;
Energy.Constraints.z_constr1=z_constr1;
Energy.Constraints.z_constr2=z_constr2;

%% solver
opts=optimoptions('intlinprog','Display','off','MaxTime',7200);

tic;
[sol,fval,exitflag,output]=solve(Energy,initial_point,'Options',opts);
MILP_time=toc;

if isempty(fval)
    disp('The solver did not return a solution.')
    return
end

result.sol=sol;
result.sol.EC=(sum(sum((data.U_es+data.W_C*data.SC).*sol.y))+sum(sum(sum(data.U_esv.*sol.x))))*data.DeltaT;
result.sol.ET=fval-result.sol.EC;
result.value=fval;
result.exitflag=exitflag;
result.output=output;
result.time=MILP_time;

end



