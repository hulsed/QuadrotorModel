function J_b=bat_obj(xb_loc,zb)

%xb_loc, the local varables for the battery
%J_b, the local objective, to acheive consistency with the variable target
%zb, the target value for the coupled variables

%constructing battery from appropriate data/calcs
 battery = design_battery(xb_loc);
 
%coupling variables/properties shared with other components yb (y means
%dependent shared variables)

    %yb1 - battery mass
    yb(1)=battery.Mass;
    %yb2 - battery cost
    yb(2)=battery.Cost;
    %yb3 - battery voltage allowed
    yb(3)=battery.Volt;
    %yb4 - battery energy stored
    yb(4)=battery.energy;
    
%calc objective - consistency between the calculated properties of the
%battery with the system optimizer's estimates/targets/what it told the
%other subsystems.
    J_b=sum((zb-yb).^2)

end