function rod = design_rod(x, prop, res)
    
    %reading appropriate data   
    matData=csvread('materialtable.csv',1,1);
    %diameters converted from inches to meters
    diameters=[0.2500, 0.3750, 0.5000, 0.6250, 0.7500, 0.8750, 1.0000, 1.1250, 1.2500, 1.3750, 1.5000]*2.54/100;
    %widths converted from inches to meters
    widths=[0.0350, 0.0580, 0.0650, 0.0830, 0.0950, 0.1250, 0.1875,  0.2500]*2.54/100;
    
    mat.Type=double(x(6));
    mat.Ymod=matData(x(6),1); %young's modulus in GPa
    mat.Sut=matData(x(6),2); %ultimate strength in MPa
    mat.Sy=matData(x(6),3); %yield strength in MPa
    mat.Dens=matData(x(6),4); %density in kg/m^3
    mat.Cost=matData(x(6),5)*(100/2.54)^3; %cost in $/m^3
    
    
    sepDist=0.25*prop.diameter+prop.diameter;
    motorDist=sepDist/sqrt(2);
    
    minRodLength=max(0.01, motorDist-res.framewidth/2);       
    length = minRodLength; %rodData(x(12),1)*2.54/100; %length converted to m
    
    diameter = diameters(x(7));
    thickness = widths(x(8));
    
    % Create the rod given everything we need
    rod.mat = mat;
    rod.Length = length;
    rod.Dia = diameter;
    rod.Thick = thickness;
    rod.Area=.5*pi*(rod.Dia^2-(rod.Dia-rod.Thick)^2);
    rod.Amoment=pi*(rod.Dia^4-(rod.Dia-rod.Thick)^4)/64; %area moment of inertia
    rod.Stiffness=(rod.Length^3/(3*rod.Amoment*1e9*rod.mat.Ymod))^-1;
    rod.Vol=rod.Length*rod.Area;
    rod.Mass=rod.Vol*rod.mat.Dens; % in kg
    rod.Cost=rod.mat.Cost*rod.Vol;
    rod.planArea=rod.Length*rod.Dia;
end
