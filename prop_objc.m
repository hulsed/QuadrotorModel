function [J_p,cp,yp] =prop_objc(xp_loc,zp, yp_shar)

%xp_loc, the local varables for propulsion
%cp, the local constraint value
%zp, the target value for the coupled variables

%note: due to the nature of the problem, constraints may need to be
%calculated inline. That is the meaning of calling this "objc"


%local variables
    
    %xp_loc 2 - angle a
    %xp_loc 3 - chord c
    
    
%shared variables from other subsystems
    %yb_shar 1 - outside system mass
    outsysMass=yp_shar(1);
    %yb_shar 1 - outside system mass
    outsysMass=yp_shar(1);
    
%shared variable in this subsystem (but optimized at the system level
    %diameter=yp_shar(2);

%construct properties of each
    motor = design_motor(xp_loc);
    [prop,foil] = design_prop(xp_loc,yp_shar);
    sysMass=outsysMass+4*(motor.Mass+prop.mass);

%call performance model
    write_propfile(prop,foil);
    [hover] = calc_hover(sysMass, motor.Num);
    
%convert performance to the correct notation
    %yp_1 - propulsion mass
    yp(1)=4*(prop.mass+motor.Mass);
    %yp_2 - propulsion cost
    yp(2)=4*(prop.cost+motor.Cost);
    %yp_3 - propulsion voltage applied
    yp(3)=hover.volts;
    %yp_4 - propulsion current applied
    yp(4)=4*hover.amps;
    %yp_5 - propulsion rpm acheived
    yp(5)=hover.rpm;
    
%calculate objective
    Jp(1)=sum(((zp(1)-yp(1))./zp(1)).^2);
    
    if yp(2)<zp(2)
        Jp(2)=0;
    else
        Jp(2)=sum(((zp(2)-yp(2))./zp(2)).^2);
    end
    
    Jp(3)=sum(((zp(3)-yp(3))./zp(3)).^2);
    
    Jp(4)=sum(((zp(4)-yp(4))./zp(4)).^2);
    
    Jp(5)=sum(((zp(5)-yp(5))./zp(5)).^2);
    
    J_p=sum(Jp);
    
    if isnan(J_p)
        J_p=inf;
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