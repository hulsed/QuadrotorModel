function Fc=sys_objc(z)

    %zb_1 - battery mass
    %zb_2 - battery cost
    %zp_3 - battery energy stored
    zb0=[0.3434,  23.9078,   1.7584e5];
    LBb=[0.0001,     0.0001,      0.0001];
    UBb=[20,     2000,     1e8];
    scaleb=[0.01, 1, 500];
    
    %zp_1 - propulsion mass
    %zp_2 - propulsion cost
    %zp_3 - propulsion voltage applied
    %zp_4 - propulsion current applied
    %zp_5 - propulsion rpm acheived
    %zp_6 - propulsion diam
    zp0=[0.0460,          119.6177,    10.8358,      23.7838,   3.2055e+04,  0.0628];
    LBp=[0.0001,     0.0001,   0.0001,     0.0001,  100,      0.025];
    UBp=[20,             1000,       50,       300,    36000,  1];
    scalep=[0.001, 10,  0.1,    0.1,    100,    0.01]; 
    
    
    %zs_1 - structures mass
    %zs_2 - structures cost
    zs0=[0.7204,5];
    LBs=[0.0001,     0.0003];
    UBs=[10,     500];
    scales=[0.001, 0.01];

UB=[UBb, UBp, UBs];
LB=[LBb, LBp, LBs];

%checks to see if in bounds
inbounds=true;
for i=1:length(UB)
    if z(i)>UB(i)
        inbounds=false;
    elseif z(i)<LB(i)
        inbounds=false;
    end
end
if inbounds

    F=sys_obj(z);

    [J_ineq, J_eq]=sys_const(z);
    conviol=[J_eq.^2,J_ineq.^2.*(J_ineq>0)];
    infeas=sum(conviol);

     
    penalty=10000;
    Fc=F+penalty*infeas;

else
    Fc=10e10;
end

end