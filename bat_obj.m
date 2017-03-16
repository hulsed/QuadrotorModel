function [J_b,yb]=bat_obj(xb_loc,zb)

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
    %yb4 - battery energy stored
    yb(3)=battery.Energy;
    
%For these variables, the response only needs to be less than the
%target--not meet it exacly.

    
%calc objective - consistency between the calculated properties of the
%battery with the system optimizer's estimates/targets/what it told the
%other subsystems.
    for i=1:2
        if yb(i)<zb(i)
            Jb(i)=0;
        else
            Jb(i)=((zb(i)-yb(i))./zb(i)).^2;
        end
    end
    Jb(3)=((zb(i)-yb(i))./zb(i)).^2;

    J_b=sum(Jb);

end