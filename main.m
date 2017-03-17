
%NOTE: find a good starting point.

    %zb_1 - battery mass
    %zb_2 - battery cost
    %zp_3 - battery energy stored
    zb0=[0.3434,  70,   1.000e5];
    LBb=[0.0001,     0.0001,      0.0001];
    UBb=[20,     2000,     1e8];
    scaleb=[0.01, 1, 500];
    
    %zp_1 - propulsion mass
    %zp_2 - propulsion cost
    %zp_3 - propulsion voltage applied
    %zp_4 - propulsion current applied
    %zp_5 - propulsion rpm acheived
    %zp_6 - propulsion diam
    zp0=[0.0460,          300,    20,      25,   3.600e+04,  0.05];
    LBp=[0.0001,     0.0001,   0.0001,     0.0001,  100,      0.025];
    UBp=[20,             1000,       50,       300,    36000,  1];
    scalep=[0.001, 10,  0.1,    0.1,    100,    0.01]; 
    
    
    %zs_1 - structures mass
    %zs_2 - structures cost
    zs0=[0.7204,10];
    LBs=[0.0001,     0.0003];
    UBs=[10,     500];
    scales=[0.001, 0.01];

UB=[UBb, UBp, UBs];
LB=[LBb, LBp, LBs];

derivx=[scaleb, scalep, scales];

startpt=[zb0,zp0,zs0];

method=3;

func=@sys_obj;
const=@sys_const;

if method==1
options = optimoptions('fmincon','Display','iter-detailed', ...
    'Algorithm', 'sqp', 'PlotFcn', {@optimplotfval}, 'TolCon', 0.1); %, 'FinDiffRelStep', derivx);
[x_star,fval,exitflag,output]=fmincon(func,startpt, [], [], [], [], LB, UB, const, options)
elseif method==2



options = psoptimset('Display','iter', 'PlotFcn', {@psplotbestf});
[x_star,fval,exitflag,output]=patternsearch(func,startpt, [], [], [], [], LB, UB, const, options)

elseif method==3
options = optimset('Display','iter','PlotFcns',@optimplotfval);
f_adapted=@sys_objc;
[x_star,fval,exitflag,output]=fminsearch(f_adapted, startpt,options)

elseif method==4
options = gaoptimset('Display', 'iter','PopulationSize', 10,'PlotFcn', {@gaplotbestf}); %, 'FinDiffRelStep', derivx);

[x_star,fval,exitflag,output]=ga(func,numel(UB), [], [], [], [], LB, UB, const, options)

end


%[x,fval,exitflag,output]=patternsearch(func,startpt, [], [], [], [], LB, UB, const, options)
%make graph
%make table

%NOTE: Pattern search could be a better idea.


%find the local variables of that optimum pt.
xb_star=x_star(1:3);
xp_star=x_star(4:9);
xs_star=x_star(10:11);



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

funcstar=sys_obj(x_star)
Jb_i=temp(1)
Jp_i=temp(2)
Js_i=temp(3)

xb_opt=temp1
xp_opt=temp2
xs_opt=temp3


