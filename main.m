
%NOTE: find a good starting point.

    %zb_1 - battery mass
    %zb_2 - battery cost
    %zp_3 - battery energy stored
    zb0=[0.33,  27.06,   1.7582e5];
    LBb=[0,     0,      0];
    UBb=[5,     200,     1e7];
    scaleb=[0.01, 1, 500];
    
    %zp_1 - propulsion mass
    %zp_2 - propulsion cost
    %zp_3 - propulsion voltage applied
    %zp_4 - propulsion current applied
    %zp_5 - propulsion rpm acheived
    %zp_6 - propulsion diam
    zp0=[0.06,  120,    2.909,  22.28,   7948,  0.203];
    LBp=[0,     0,      0,      0,      0,      0];
    UBp=[1,     600,    36,     300,    36000,  1];
    scalep=[0.001, 10,  0.1,    0.1,    100,    0.01]; 
    
    
    %zs_1 - structures mass
    %zs_2 - structures cost
    zs0=[0.0709,2.6292];
    LBs=[0,     0];
    UBs=[1,     5];
    scales=[0.001, 0.01];

LB=[LBb, LBp, LBs];
UB=[UBb, UBp, UBs];

derivx=[scaleb, scalep, scales];

startpt=[zb0,zp0,zs0];

method=2;

func=@sys_obj;
const=@sys_const;

if method==1
options = optimoptions('fmincon','Display','iter-detailed', 'TolConSQP', 0.15, ...
    'Algorithm', 'sqp', 'PlotFcn', {@optimplotfval}); %, 'FinDiffRelStep', derivx);
[x,fval,exitflag,output]=fmincon(func,startpt, [], [], [], [], LB, UB, const, options)
elseif method==2



options = psoptimset('Display','iter', 'Cache', 'on', 'PlotFcn', {@psplotbestf},...
    'PenaltyFactor', 1000, 'TolBind', 0.3,'PollMethod', 'MADSPositiveBasisNp1',...
    'InitialMeshSize', 1000 );
[x_star,fval,exitflag,output]=patternsearch(func,startpt, [], [], [], [], LB, UB, const, options)

elseif method==3
options = optimset('Display','iter','PlotFcns',@optimplotfval);
f_adapted=@sys_objc;
[x_star,fval,exitflag,output]=fminsearch(f_adapted, startpt,options)
end


%[x,fval,exitflag,output]=patternsearch(func,startpt, [], [], [], [], LB, UB, const, options)
%make graph
%make table

%NOTE: Pattern search could be a better idea.


%find the local variables of that optimum pt.
xb_star=x_star(1:4);
xp_star=x_star(5:12);
xs_star=x_star(13:14);



%this is where subsystem responses are calculated
for i=1:3
    if i==1
        %battery: do an exhaustive search of the possible configurations (small
        %space, little computational cost)
        [temp(i),temp1]=opt_bat(xb_star,xp_star,xs_star);

    elseif i==2
        %propeller: ga?
        [temp(i),temp2]=opt_prop(xb_star,xp_star,xs_star);
    elseif i==3
        %structure: use ga
        [temp(i),temp3]=opt_struct(xb_star,xp_star,xs_star);
    end
end

Jb_i=temp(1)
Jp_i=temp(2)
Js_i=temp(3)

xb_opt=temp1
xp_opt=temp2
xs_opt=temp3


