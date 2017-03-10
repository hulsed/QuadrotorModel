function J_s=struct_obj(xs_loc,zs)

%xs_loc, the local varables for structures
%zs, the target value for the coupled variables

%local variables
    %xp_loc 1 - choice of material
    %xp_loc 2 - diameter
    %xp_loc 3 - thickness
    %xp_loc 4 - length

%constructing rod from appropriate data/calcs
    rod = design_rod(xs_loc)

%coupling variables/properties shared with other components yb (y means
%dependent shared variables)    
    %ys_1 - structures mass
    ys(1)=4*rod.Mass;
    %ys_2 - structures cost
    ys(2)=4*rod.Cost;
    
%calc objective - consistency between the calculated properties of the
%rod with the system optimizer's estimates/targets/what it told the
%other subsystems.
    
    J_s=sum((zs-ys).^2)
    
end