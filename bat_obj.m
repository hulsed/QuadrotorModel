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
    %must be less than or equal to target
    if yb(1)<zb(1)
        Jb(1)=0;
    else
        Jb(1)=((zb(1)-yb(1))./zb(1)).^2;
    end
    %yb2 - battery cost
    yb(2)=battery.Cost;
    %must be less than or equal to target
    if yb(2)<zb(2)
        Jb(2)=0;
    else
        Jb(2)=((zb(2)-yb(2))./zb(2)).^2;
    end
    %yb4 - battery energy stored
    yb(3)=battery.Energy;
    %must be greater than or equal to target
    if yb(3)>zb(3)
        Jb(3)=0;
    else
        Jb(3)=((zb(3)-yb(3))./zb(3)).^2;
    end
       
%calc objective - consistency between the calculated properties of the
%battery with the system optimizer's estimates/targets/what it told the
%other subsystems.

    J_b=sum(Jb);

end