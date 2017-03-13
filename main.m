

%NOTE: find a good starting point.

    %zb_1 - battery mass
    %zb_2 - battery cost
    %zb_3 - battery voltage allowed
    %zp_4 - battery energy stored
    zb0=[0.33,27.06,22.2,1.7582e5];
    
    %zp_1 - propulsion mass
    %zp_2 - propulsion cost
    %zp_3 - propulsion voltage applied
    %zp_4 - propulsion current applied
    %zp_5 - propulsion thrust acheived
    %zp_6 - propulsion rpm acheived
    %zp_7 - propulsion power used
    %zp_7 - propulsion diam
    zp0=[1,1,1,1,1,1,1,1];
    
    %zs_1 - structures mass
    %zs_2 - structures cost
    zs0=[1,1];

LB=[0,0,0,0,0,0,0,0,0,0,0,0,0,0];
UB=[ [], [], [], [], [], [], [], [], [], [], [], [], []];

startpt=[zb0,zp0,zs0];

func=@sys_obj;
const=@sys_const;

%options = optimoptions('fmincon','Display','iter-detailed');
options = psoptimset('PlotFcn', @psplotbestf,'Display','iter-detailed', 'Cache', 'on');
[x,fval,exitflag,output]=patternsearch(func,startpt, [], [], [], [], LB, UB, const, options)
%NOTE: Pattern search could be a better idea.