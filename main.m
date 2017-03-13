

%NOTE: find a good starting point.
zb0=[1,1,1,1];
zp0=[1,1,1,1,1,1,1,1];
zs0=[1,1];

LB=[0,0,0,0,0,0,0,0,0,0,0,0,0,0];
UB=[ [], [], [], [], [], [], [], [], [], [], [], [], []];

startpt=[zb0,zp0,zs0];

func=@sys_obj;
const=@sys_const;

options = optimoptions('fmincon','Display','iter-detailed');
[x,fval,exitflag,output]=fmincon(func,startpt, [], [], [], [], LB, UB, const, options)