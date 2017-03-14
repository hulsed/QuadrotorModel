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
    propThrust=ys_shar(4)/4;
    
%local variables
    %xp_loc 1 - choice of material
    %xp_loc 2 - diameter
    %xp_loc 3 - thickness
    %xp_loc 4 - length

%constructing rod from appropriate data/calcs
    rod = design_rod(xs_loc);

%local constraint calcs
    %cs_1 - rod must be long enough to prevent collision
    resFramewidth=0.075;
    sepDist=1.25*propDiameter;
    motorDist=sepDist/sqrt(2); 
    minRodLength=max(0.01, motorDist-resFramewidth/2);       
    
    cs(1)=1-rod.Length/minRodLength;
    
    %cs_2 - rod must not meet vibrational requirements
    forcedFreq=propRpm/60; %converting to hz
    minnatFreq=2*forcedFreq; %natural frequency must be two times the forced frequency.
    natFreq=sqrt(rod.Stiffness./(0.5*rod.Mass+propMass/4))/(2*pi);
    
    cs(2)=1-natFreq/minnatFreq;
    
    %cs_3 - rod must meet deflection requirements
    maxDefl=0.01*rod.Length;
    defl=propThrust/rod.Stiffness;
    
    cs(3)=defl/maxDefl-1;
    
    
end