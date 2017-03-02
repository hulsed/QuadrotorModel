function [obj, constraints] = calc_obj(battery, motor, prop, foil, rod, sys)
    
    failure=0;
    %write prop file for qprop
    write_propfile(prop,foil);
    %calculate hover performance
    [hover] = calc_hover(sys);

    %Calculation to find out if any of the objective failed
    if isnan(hover.pelec)
        failure=1;
    elseif hover.failure==1
        failure=1;
    end
    % Calculation of Constraints (only possible with performance data) 
        [constraints]=calc_constraints(battery,motor,prop,foil,rod,sys,hover,failure);
  
    %gives a poor performance in case the model breaks
   if failure
        obj = -10000;
   else
    % Calculates objectives
    Objectives.totalCost =sys.cost;
    Objectives.flightTime = battery.Energy /(4*hover.pelec+sys.power); %note: power use is for EACH motor.

    %Adding Objectives together...
    obj=Objectives.flightTime-3*(Objectives.totalCost);
   end
end
