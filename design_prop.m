function [prop,foil] = design_prop(x_int, x_cont)
    
    %read appropriate data
    foilData = csvread('airfoiltable.csv', 1, 1); %load starting from 2nd row, 2nd col
    
    % Propeller Calculations
    prop.root=0.005; %defines where the root of the propeller begins along the radius
    
    % create available options 
    %diameters=linspace(prop.root*2+0.01,0.2,12); %range is from 1 cm past the root to 0.2 meters
    %angles=linspace(0,45,10); %min angle, max angle, num pts
    %twists=linspace(0,1,10); %min twist, max twist, num pts
    %chords=linspace(0.005,0.02,10); %min chord, max chord, num pts (in m)
    %tapers=linspace(0,1,10); %min taper, max taper, num pts
    
    % pick option
    %prop.diameter=diameters(x(6));
    %prop.angleAve=angles(x(7));
    %prop.angleTwist=twists(x(8));
    %prop.chordAve=chords(x(9));
    %prop.chordTaper=tapers(x(10));
    
    %assign to prop struct
    prop.diameter=x_cont(1);
    prop.angleAve=x_cont(2);
    prop.angleTwist=x_cont(3);
    prop.chordAve=x_cont(4);
    prop.chordTaper=x_cont(5);
    
    %transform to geometry
    prop.angleTip=2*prop.angleAve/(1/prop.angleTwist+1);
    prop.angleRoot=2*prop.angleAve/(prop.angleTwist+1);
    prop.chordTip=2*prop.chordAve/(1/prop.chordTaper+1);
    prop.chordRoot=2*prop.chordAve/(prop.chordTaper+1);
    
    %Foil Calculations
    foil.Cl0=foilData(x_int(5),1);
    foil.Cla=foilData(x_int(5),2)*360/(2*pi); %converting to 1/deg to 1/rad
    foil.Clmin=foilData(x_int(5),3);
    foil.Clmax=foilData(x_int(5),4);
    foil.Cd0=foilData(x_int(5),5);
    foil.Cd2=foilData(x_int(5),6)*360/(2*pi); %converting to 1/deg to 1/rad
    foil.Clcd0=foilData(x_int(5),7);
    foil.Reref=foilData(x_int(5),8);
    foil.Reexp=foilData(x_int(5),9);
    foil.Num=foilData(x_int(5),10);
    
    K_A=0.60; % via https://ocw.mit.edu/courses/aeronautics-and-astronautics/16-01-unified-engineering-i-ii-iii-iv-fall-2005-spring-2006/systems-labs-06/spl10b.pdf
    K_I=0.036;
    
    foilnum=['NACA00' num2str(foil.Num)];
    prop.avgThickness=0.01*foil.Num*prop.chordAve;
    prop.xsArea=K_A*prop.avgThickness*prop.chordAve; %assuming may be approximated as a triangle
    vol=prop.xsArea*prop.diameter;
    %Note: assuming propeller is polycarb (1190 kg/m^3)
    prop.thickRoot=0.01*foil.Num*prop.chordRoot;
    prop.areaRoot=K_A*prop.thickRoot*prop.chordRoot;
    camber=0;
    prop.amomentRoot=K_I*prop.thickRoot*prop.chordRoot*(prop.thickRoot.^2 + camber^2);
    
    prop.mass=vol*1190;
    %Note: assuming propeller is polycarb (0.29 $/in^3)
    costdens=0.29*(100/2.54)^3;
    prop.cost=costdens*vol;
    prop.sy=55; %yield strength, mPa
    prop.modulus=2; %young's modulus, GPa
    
    write_propfile(prop,foil);
end