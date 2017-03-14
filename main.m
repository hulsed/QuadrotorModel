

%NOTE: find a good starting point.

    %zb_1 - battery mass
    %zb_2 - battery cost
    %zb_3 - battery voltage allowed
    %zp_4 - battery energy stored
    zb0=[0.33,  27.06,  22.2,   1.7582e5];
    LBb=[0,     0,      0,      0];
    UBb=[5,     200,    48,     1e7];
    
    %zp_1 - propulsion mass
    %zp_2 - propulsion cost
    %zp_3 - propulsion voltage applied
    %zp_4 - propulsion current applied
    %zp_5 - propulsion thrust acheived
    %zp_6 - propulsion rpm acheived
    %zp_7 - propulsion power used
    %zp_7 - propulsion diam
    zp0=[0.06,  120,    2.909,  22.28,  7.52,   7948,   64.84,  0.203];
    LBp=[0,     0,      0,      0,      0,      0,      0,      0];
    UBp=[1,     600,    36,     300,    100,    36000,  500,    1];
    
    
    %zs_1 - structures mass
    %zs_2 - structures cost
    zs0=[0.0709,2.6292];
    LBs=[0,     0];
    UBs=[1,     5];

LB=[LBb, LBp, LBs];
UB=[UBb, UBp, UBs];

startpt=[zb0,zp0,zs0];

func=@sys_obj;
const=@sys_const;

options = optimoptions('fmincon','Display','iter-detailed', 'TolConSQP', 0.1, 'PlotFcn', {@optimplotfval});
%options = psoptimset('PlotFcn', @psplotbestf,'Display','iter', 'Cache', 'on');
[x,fval,exitflag,output]=fmincon(func,startpt, [], [], [], [], LB, UB, const, options)

%make graph
%make table

%NOTE: Pattern search could be a better idea.


%find the local variables of that optimum pt.
xb=x(1:4);
xp=x(5:12);
xs=x(13:14);

parfor i=1:3
    if i==1
        %battery: do an exhaustive search of the possible configurations (small
        %space, little computational cost)
        [temp(i),xb_opt(1:4)]=opt_bat(zb,zp,zs)

    elseif i==2
        %propeller: ga?
        [temp(i),xp_opt(1:7)] =opt_prop(zb,zp,zs)
    elseif i==3
        %structure: use ga
        [temp(i), xs_opt(1:2)]=opt_struct(zb,zp,zs)
    end
end

xb_opt
zb
xp_opt
zp
xs_opt
zs


