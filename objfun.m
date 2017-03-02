function obj=objfun(actions)
    
    %importing data
    [batteryData, motorData, propData, foilData, rodData, matData] = load_data('batterytable.csv', ...
    'motortable.csv', 'propranges.csv', 'airfoiltable.csv','rodtable.csv','materialtable.csv');

    data.batteryData = batteryData; data.motorData = motorData;
    data.propData = propData; data.foilData = foilData; data.rodData = rodData;
    data.matData = matData;              
    
    % "non-designed" parts of the design.
    res.mass=0.3;
    res.framewidth=0.075; %temp width of frame!
    res.planArea=res.framewidth^2;
    res.cost=50;
    res.power=5;
    %design of system and subsystems
    motorNum = actions(4); % remember motor number so we can get the right motorfile
    battery = design_battery(actions, batteryData);
    motor = design_motor(actions, motorData);
    [prop,foil] = design_prop(actions, propData, foilData);
    rod = design_rod(actions, rodData, matData, prop,res);
    sys=design_sys(battery, motor, prop, foil, rod, res, motorNum);

    [G,Objectives, constraints] = calc_obj(battery, motor, prop, foil, rod, sys);
        
        %end
    obj=-G;
end


