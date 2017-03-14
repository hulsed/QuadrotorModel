function [prop,foil] = design_prop(xp_loc)
    
    %read appropriate data
    propData = csvread('propranges.csv', 1, 0); %load starting from 2nd row
    foilData = csvread('airfoiltable.csv', 1, 1); %load starting from 2nd row, 2nd col
    
    % Propeller Calculations
    %prop.airfoil = propData(xp_loc(2), 1); % propeller prop.airfoil
    diameter = propData(xp_loc(2), 2)*0.0254; % diameter (inch->m)
    angle = propData(xp_loc(3), 3); % blade angle at root
    chord = propData(xp_loc(4), 5)*0.0254; % chord at root (inch->m)
    
    %Foil Calculations
    foil.Cl0=foilData(xp_loc(1),1);
    foil.Cla=foilData(xp_loc(1),2)*360/(2*pi); %converting to 1/deg to 1/rad
    foil.Clmin=foilData(xp_loc(1),3);
    foil.Clmax=foilData(xp_loc(1),4);
    foil.Cd0=foilData(xp_loc(1),5);
    foil.Cd2=foilData(xp_loc(1),6)*360/(2*pi); %converting to 1/deg to 1/rad
    foil.Clcd0=foilData(xp_loc(1),7);
    foil.Reref=foilData(xp_loc(1),8);
    foil.Reexp=foilData(xp_loc(1),9);
    foil.Num=foilData(xp_loc(1),10);
    
    
    %Assign prop characteristics to struct
    prop.diameter = diameter; % meters
    prop.angleTip = angle; % blade angle at tip
    prop.angleRoot = angle; % blade angle at root
    prop.chordRoot=chord; % chord at root (inch->m)
    prop.chordTip=chord; % chord at root (inch->m)
    
    %prop.chordTip = chordTip; % chord at tip (inch->m)
    
    chordAvg=mean([prop.chordRoot, prop.chordTip]);
    foilnum=['NACA00' num2str(foil.Num)];
    avgThickness=0.01*foil.Num*chordAvg;
    xsArea=0.5*avgThickness*chordAvg; %assuming may be approximated as a triangle
    vol=xsArea*diameter;
    %Note: assuming propeller is polycarb (1190 kg/m^3)
    mass=vol*1190;
    %Note: assuming propeller is polycarb (0.29 $/in^3)
    costdens=0.29*(100/2.54)^3;
    cost=costdens*vol;
    
    prop.mass=mass;
    prop.cost=cost;
    write_propfile(prop,foil);
end