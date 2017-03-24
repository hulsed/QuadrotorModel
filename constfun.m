function [con,ceq]=constfun(x)
               
        % "non-designed" parts of the design.
    res=res_assumptions();
    %design of subsystems
    battery = design_battery(x);
    motor = design_motor(x);
    [prop,foil] = design_prop(x);
    rod = design_rod(x, prop,res);
    %design of system
    sys=design_sys(battery, motor, prop, foil, rod, res);
    %calculate objective
    [obj, constraints] = calc_obj(battery, motor, prop, foil, rod, sys);
    
    con=constraints';
    ceq=[];
end