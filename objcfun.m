function obj=objcfun(x)           
    
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
    [obj1, constraints] = calc_obj(battery, motor, prop, foil, rod,esc, sys);
    
    conviol=max(0,constraints);

    obj=-obj1+2000*sum((1+conviol).^2-1);
    if isnan(obj) || obj>20000
        obj=20000;
    end
end


