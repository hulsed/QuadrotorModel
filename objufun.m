function obj=objufun(x)           
    
    % "non-designed" parts of the design.
    res=res_assumptions();
    %design of subsystems
    battery = design_battery(x);
    motor = design_motor(x);
    [prop,foil] = design_prop(x);
    rod = design_rod(x, prop,res);
    esc = design_esc(x);
    %design of system
    sys=design_sys(battery, motor, prop, foil, rod,esc, res);
    %calculate objective
    [obj, constraints] = calc_obj(battery, motor, prop, foil, rod,esc, sys);
    obj=-obj;
    %conviol=max(0,constraints);

    %obj=-obj1+1000*sum(conviol.^2);
    if isnan(obj) || obj>10000
        obj=10000;
    end
end


