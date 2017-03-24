function [obj, constraints] = calc_obj(battery, motor, prop, foil, rod,esc, sys)
    
    failure=0;
    %write prop file for qprop
    write_propfile(prop,foil);
    %calculate hover performance
    [hover] = calc_hover(sys);
    ClimbVel=10; %velocity requirement for climb: 10 m/s (22 mph)
    [climb] = calc_climb(sys,ClimbVel);

    
    % Calculation of Constraints (only possible with performance data) 
        [constraints]=calc_constraints(battery,motor,prop,foil,rod,esc,sys,hover,failure);
        
        
    % Calculates objectives
    Objectives.totalCost =sys.cost;
    Objectives.flightTime = battery.Energy /(4*hover.pelec+sys.power); %note: power use is for EACH motor.
    distance= 300; % climb distance in meters--temp, should be specified elsewhere
    time=distance/ClimbVel;
    Objectives.climbEnergy=time*(4*climb.pelec+sys.power);
    objcal=Objectives.flightTime+(-Objectives.climbEnergy)/5-3*(Objectives.totalCost);
    
    %Calculation to find out if any of the objective failed
    if isnan(hover.pelec)
        failure=1;
    elseif hover.failure==1
        failure=1;
    elseif climb.failure==1
        failure=1;
    elseif isnan(objcal)
        failure=1
    end
    
    %gives a poor performance in case the model breaks
   if failure
        obj = -10000;
   else
    obj=objcal;
   end
   
end