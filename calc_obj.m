function [obj, constraints] = calc_obj(battery, motor, prop, foil, rod,esc,landingskid, sys, oper)
    
    failure=0;
    %write prop file for qprop
    write_propfile(prop,foil);
    %calculate hover performance
    [hover] = calc_hover(sys);
    [climb] = calc_climb(sys,oper.climbvel);
    [flight]=calc_flight(sys,oper.flightangle);
    
    mission=calc_mission(sys,hover,climb, flight);
    
    % Calculation of Constraints (only possible with performance data) 
        [constraints_h]=calc_constraints(battery,motor,prop,foil,rod,esc,landingskid,sys,hover,failure);
        [constraints_c]=calc_constraints(battery,motor,prop,foil,rod,esc,landingskid,sys,climb,failure);
        [constraints_f]=calc_constraints(battery,motor,prop,foil,rod,esc,landingskid,sys,flight,failure);
        
        constraints=[constraints_h, constraints_c, constraints_f];
        
    % Calculates objectives
    objcal=-10*mission.value+sys.cost;
    
    %Calculation to find out if any of the objective failed
    if isnan(hover.pelec)
        failure=1;
    elseif hover.failure==1
        failure=1;
    elseif climb.failure==1
        failure=1;
    elseif flight.failure==1
        failure=1;
    elseif isnan(objcal)
        failure=1;
    end
    
    %gives a poor performance in case the model breaks
   if failure
        obj = -10000;
   else
        obj=objcal;
   end
   
end
