function obj=objfun(x)
                
    
    % "non-designed" parts of the design.
    res.mass=0.3;
    res.framewidth=0.075; %temp width of frame!
    res.planArea=res.framewidth^2;
    res.cost=50;
    res.power=5;
    %design of subsystems
    battery = design_battery(x);
    motor = design_motor(x);
    [prop,foil] = design_prop(x);
    rod = design_rod(x, prop,res);
    %design of system
    sys=design_sys(battery, motor, prop, foil, rod, res);
    %calculate objective
    [G,Objectives, constraints] = calc_obj(battery, motor, prop, foil, rod, sys);

    obj=-G;
end


