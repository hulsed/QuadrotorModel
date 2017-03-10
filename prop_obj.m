function J_p=prop_obj(xp_loc,zp)

%xp_loc, the local varables for propulsion
%cp, the local constraint value
%zp, the target value for the coupled variables

%xp_loc 1 - choice of motor
%xp_loc 2 - foil
%xp_loc 3 - diam
%xp_loc 4 - ar
%xp_loc 5 - at
%xp_loc 6 - cr
%xp_loc 7 - ct

%construct properties of each
    motor = design_motor(xp_loc);
    [prop,foil] = design_prop(xp_loc);

%call performance model
    write_propfile(prop,foil);
    [hover] = calc_hover(sys);
    
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
    
%calculate objective
    J_p=(zp-yp).^2;
    
end