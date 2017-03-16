function [J_s,ys]=struct_obj(xs_loc,zs,ys_shar)

%xs_loc, the local varables for structures
%zs, the target value for the coupled variables

%local variables
    %xp_loc 1 - material 
    %xp_loc 2 - diameter
    %xp_loc 3 - thickness

%constructing rod from appropriate data/calcs
    rod = design_rod(xs_loc,ys_shar);

%coupling variables/properties shared with other components yb (y means
%dependent shared variables)    
    %ys_1 - structures mass
    ys(1)=4*rod.Mass;
    %ys_2 - structures cost
    ys(2)=4*rod.Cost;
    
%calc objective - consistency between the calculated properties of the
%rod with the system optimizer's estimates/targets/what it told the
%other subsystems.
    
    %For these variables, the response only needs to be less than the
    %target--not meet it exacly.
    for i=1:2
        if ys(i)<zs(i)
            Js(i)=0;
        else
            Js(i)=((zs(i)-ys(i))/zs(i))^2;
        end  
    end
    
    J_s=sum(Js);
    
end