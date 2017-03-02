function [prop,foil] = design_prop(x)
    
    %read appropriate data
    propData = csvread('propranges.csv', 1, 0); %load starting from 2nd row
    foilData = csvread('airfoiltable.csv', 1, 1); %load starting from 2nd row, 2nd col
    
    % Propeller Calculations
    %prop.airfoil = propData(x(5), 1); % propeller prop.airfoil
    diameter = propData(x(6), 2)*0.0254; % diameter (inch->m)
    angleRoot = propData(x(7), 3); % blade angle at root
    angleTip = propData(x(8), 4); % blade angle at tip
    chordRoot = propData(x(9), 5)*0.0254; % chord at root (inch->m)
    chordTip = propData(x(10), 6)*0.0254; % chord at tip (inch->m)
    
    %Foil Calculations
    foil.Cl0=foilData(x(5),1);
    foil.Cla=foilData(x(5),2)*360/(2*pi); %converting to 1/deg to 1/rad
    foil.Clmin=foilData(x(5),3);
    foil.Clmax=foilData(x(5),4);
    foil.Cd0=foilData(x(5),5);
    foil.Cd2=foilData(x(5),6)*360/(2*pi); %converting to 1/deg to 1/rad
    foil.Clcd0=foilData(x(5),7);
    foil.Reref=foilData(x(5),8);
    foil.Reexp=foilData(x(5),9);
    foil.Num=foilData(x(5),10);
    
    
    %Assign prop characteristics to struct
    prop.diameter = diameter; % meters
    prop.angleRoot = angleRoot; % blade angle at root
    prop.angleTip = angleTip; % blade angle at tip
    prop.chordRoot = chordRoot; % chord at root (inch->m)
    prop.chordTip = chordTip; % chord at tip (inch->m)
    
    chordAvg=mean([chordRoot, chordTip]);
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
end