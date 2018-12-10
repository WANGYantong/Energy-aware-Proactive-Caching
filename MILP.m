function  result=MILP(flow,data,para)

%% parameter tailor
NF=length(flow);

data.S_k=data.S_k(1:NF);
data.delay_k=data.delay_k(1:NF);
data.probability_ka=data.probability_ka(1:NF,:);

%% decision variable
x=optimvar('x',length(para.EdgeCloud),data.N_e,data.N_es,'Type','integer',...
    'LowerBound',0,'UpperBound',1);
y=optimvar('y',length(para.EdgeCloud),data.N_e,'Type','integer',...
    'LowerBound',0,'UpperBound',1);
pi=optimvar('pi',NF,length(para.EdgeCloud),data.N_e,data.N_es,'Type','integer',...
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

%% objective function
EC=sum(sum((data.U_es+data.W_C*data.SC).*y))+sum(sum(sum(data.U_esv.*x)));

pi_mid=squeeze(sum(sum(pi,4),3));
% the code below need double check !!!
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

%% solver
opts=optimoptions('intlinprog','Display','off','MaxTime',1800);

tic;
[sol,fval,exitflag,output]=solve(Energy,'Options',opts);
MILP_time=toc;

if isempty(sol)
    disp('The solver did not return a solution.')
    return
end

result.sol=sol;
result.sol.EC=sum(sum((data.U_es+data.W_C*data.SC).*sol.y))+sum(sum(sum(data.U_esv.*sol.x)));
result.sol.ET=fval-result.sol.EC;
result.value=fval;
result.exitflag=exitflag;
result.output=output;
result.time=MILP_time;

end



