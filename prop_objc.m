function [J_p,cb] =prop_objc(xp_loc,zp, yb_shar)

%xp_loc, the local varables for propulsion
%cp, the local constraint value
%zp, the target value for the coupled variables

%note: due to the nature of the problem, constraints may need to be
%calculated inline. That is the meaning of calling this "objc"

%local variables
    %xp_loc 1 - choice of motor
    %xp_loc 2 - foil
    %xp_loc 3 - diam
    %xp_loc 4 - ar
    %xp_loc 5 - at
    %xp_loc 6 - cr
    %xp_loc 7 - ct
%shared variables from other subsystems
    %yb_shar 1 - outside system mass
    outsysMass=yb_shar(1);

%construct properties of each
    motor = design_motor(xp_loc);
    [prop,foil] = design_prop(xp_loc);
    sysMass=outsysMass+4*(motor.Mass+prop.mass);

%call performance model
    write_propfile(prop,foil);
    [hover] = calc_hover(sysMass, motor.Num);
    
%convert performance to the correct notation
    %yp_1 - propulsion mass
    yp(1)=4*(prop.mass+motor.Mass);
    %yp_2 - propulsion cost
    yp(2)=4*(prop.cost+motor.cost);
    %yp_3 - propulsion voltage applied
    yp(3)=hover.volts;
    %yp_4 - propulsion current applied
    yp(4)=4*hover.amps;
    %yp_5 - propulsion thrust acheived
    yp(5)=4*hover.thrust;
    %yp_6 - propulsion rpm acheived
    yp(6)=hover.rpm;
    %yp_7 - propulsion power used
    yp(7)=hover.pelec;
    %yp_8 - propulsion prop diameter
    yp(8)=prop.diameter;
    
%calculate objective
    J_p=(zp-yp).^2;
    
%calculate constraints
    %cb_1 - doesn't use more current than the limit
    cb(1)=hover.amps/motor.Imax-1;
    %cb_2 - doesn't use more power than the limit
    cb(2)=hover.pelec/motor.Pmax-1;
    %cb(3) - must be capable of supplying the required thrust
    cb(3)=hover.thrust/(sysMass*9.81/4)-1;
    %cb_4 - must not cause collision with 

    
end