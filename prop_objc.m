function [J_p,cp,yp] =prop_objc(xp_loc,zp, yp_shar)

%xp_loc, the local varables for propulsion
%cp, the local constraint value
%zp, the target value for the coupled variables

%note: due to the nature of the problem, constraints may need to be
%calculated inline. That is the meaning of calling this "objc"


%local variables
    
    %xp_loc 1 - angle a
    %xp_loc 2 - chord c
    %xp_loc 2 - diameter
    
    
%shared variables from other subsystems
    %yb_shar 1 - outside system mass
    outsysMass=yp_shar(1);

%construct properties of each
    motor = design_motor(xp_loc);
    [prop,foil] = design_prop(xp_loc);
    sysMass=outsysMass+4*(motor.Mass+prop.mass);

%call performance model
    write_propfile(prop,foil);
    [hover] = calc_hover(sysMass, motor.Num);
    
%convert performance to the correct notation and calculate objectives
    %yp_1 - propulsion mass
    yp(1)=4*(prop.mass+motor.Mass);
    %must be equal to target
    Jp(1)=((zp(1)-yp(1))./zp(1)).^2;
    %yp_2 - propulsion cost
    yp(2)=4*(prop.cost+motor.Cost);
    %must be less than or equal to target
    if yp(2)<zp(2)
        Jp(2)=0;
    else
        Jp(2)=((zp(2)-yp(2))./zp(2)).^2;
    end
    %yp_3 - propulsion voltage applied
    yp(3)=hover.volts;
    %must be less than or equal to target
    if yp(3)<zp(3)
        Jp(3)=0;
    else
        Jp(3)=((zp(3)-yp(3))./zp(3))^2;
    end
    %yp_4 - propulsion current applied
    yp(4)=4*hover.amps;
    %must be less than or equal to target
    if yp(4)<zp(4)
        Jp(4)=0;
    else
        Jp(4)=((zp(4)-yp(4))./zp(4))^2;
    end
    %yp_5 - propulsion rpm acheived
    yp(5)=hover.rpm;
    %must be less than or equal to target
    if yp(5)<zp(5)
        Jp(5)=0;
    else
        Jp(5)=((zp(5)-yp(5))./zp(5))^2;
    end
    %yp(6) - diameter (same as local variable)
    yp(6)=xp_loc(3);
    %must be near target
    Jp(6)=((zp(6)-yp(6))./zp(6))^2;

%sum objectives
    J_p=sum(Jp);
    
    if isnan(J_p)
        J_p=10e8;
    end
    
%calculate constraints
    %cb_1 - doesn't use more current than the limit
    cp(1)=hover.amps/motor.Imax-1;
    %cb_2 - doesn't use more power than the limit
    cp(2)=hover.pelec/motor.Pmax-1;
    %cb(3) - must be capable of supplying the required thrust
    cp(3)=1-hover.thrust/(sysMass*9.81/4);
    %cb_4 - must not cause collision with 
    
    for i=1:length(cp)
        if isnan(cp(i))
            cp(i)=1e9;
        end
    end
    
end