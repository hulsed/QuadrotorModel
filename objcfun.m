function [obj,obj1,con]=objcfun(x_int,x_cont)           
    
    % "non-designed" parts of the design.
    res=res_assumptions();
    %design of subsystems
    battery = design_battery(x_int);
    motor = design_motor(x_int);
    [prop,foil] = design_prop(x_int,x_cont);
    rod = design_rod(x_int,x_cont, prop,res);
    esc = design_esc(x_int);
    landingskid=design_landingskid(x_int,x_cont,res);
    
    oper.climbvel=x_cont(12);
    oper.flightangle=x_cont(13);  
    
    %design of system
    sys=design_sys(battery, motor, prop, foil, rod,esc,landingskid, res);
    %calculate objective
    
    [obj1, constraints] = calc_obj(battery, motor, prop, foil, rod,esc,landingskid, sys, oper);
    
    conviol=max(0,constraints);
    
    %con=sum((1+conviol).^2-1);
    
    con=sum(conviol.^2);
    
    if con<=0.1
        con=0;
    end
    
    obj=obj1+10000*sum((1+conviol).^2-1);
    if isnan(obj) || obj>20000
        obj=1e8;
    end
end


