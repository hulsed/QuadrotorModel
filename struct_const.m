function cs= struct_const(xs_loc, ys_shar)

%xs_loc, the local varables for structures
%yb_shar, the estimates/targets of the responses from the other subsystems
    
    %ys_shar 1 - Prop diameter
    propDiameter=ys_shar(1);
    %ys_shar 2 - Motor RPM
    propRpm=ys_shar(2);
    %ys_shar 3 - propulsion mass
    propMass=ys_shar(3)/4;
    %ys_shar 4 - delivered thrust
    OutsideSysMass=ys_shar(4);
    
%local variables
    %xp_loc 1 - material
    %xp_loc 2 - diameter
    %xp_loc 2 - thickness

%constructing rod from appropriate data/calcs
    rod = design_rod(xs_loc,ys_shar);

%local constraint calcs
   
    %cs_1 - rod must meet vibrational requirements
    forcedFreq=propRpm/60; %converting to hz
    minnatFreq=2*forcedFreq; %natural frequency must be two times the forced frequency.
    natFreq=sqrt(rod.Stiffness./(0.5*rod.Mass+propMass/4))/(2*pi);
    
    cs(1)=1-natFreq/minnatFreq;
    
    %cs_2 - rod must meet deflection requirements--must hold up system on
    %its own.
    maxDefl=0.01*rod.Length;
    forceheld=9.81*(OutsideSysMass+4*rod.Mass)/4;
    defl=forceheld/rod.Stiffness;
    cs(2)=defl/maxDefl-1;
    
    
end