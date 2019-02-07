clc;
clear;
ave_t = zeros(10,100);
p = zeros(10,100);
nn = 10:10:5000;    %customers
% nn = 10:10:100;

for d = 1:length(nn)
    for s = 1:100 
        n = nn(d);    %total number of arrivals
        dt = exprnd(6.7,1,n);    %lambda = 0.1493
        st = exprnd(6.3,1,n);    %mu = 0.1587
        a = zeros(1,n);    %arrival time
        b = zeros(1,n);    %service time
        c = zeros(1,n);    %leaving time
        a(1) = 0;
        
        for i = 2:n
            a(i) = a(i-1) + dt(i-1);
        end
        
        b(1) = 0;
        c(1) = b(1) + st(1);
        
        for i = 2:n
%new customer arrives before last one leave 
           if(a(i) <= c(i-1))
               b(i) = c(i-1);
%when new one comes, the waiting queue is empty
           else
               b(i) = a(i);
           end
%update current one leaving time
           c(i) = b(i) + st(i);
       end
                     
        cost = zeros(1,n);
        for i = 1:n
            cost(i)=c(i)-a(i);    %sojourn time
        end
        T = c(n);    %total sojourn time
        p(d,s) = sum(st)/T; %busy time probability
        ave_t(d,s) = sum(cost)/n; %averave sojourn time
    end
end
pc = sum(p,2)/100;    %busy time probability after 100 monte carlo
aver_tc = sum(ave_t,2) / 100;    %average sojourn time after 100 monte carlo

figure;
plot(nn,aver_tc);
grid on;
title('Average Waiting Time  Unit: second')
xlabel('The number of arriving')
ylabel('Average Waiting Time')   

