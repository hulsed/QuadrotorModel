function rod = design_rod(x, prop, res)
    
    %reading appropriate data   
    rodData= csvread('rodtable.csv',1,0);
    matData=csvread('materialtable.csv',1,1);
    
    mat.Type=double(x(11));
    mat.Ymod=matData(x(11),1); %young's modulus in GPa
    mat.Sut=matData(x(11),2); %ultimate strength in MPa
    mat.Sy=matData(x(11),3); %yield strength in MPa
    mat.Dens=matData(x(11),4); %density in kg/m^3
    mat.Cost=matData(x(11),5)*(100/2.54)^3; %cost in $/m^3
    
    
    sepDist=0.25*prop.diameter+prop.diameter;
    motorDist=sepDist/sqrt(2);
    
    minRodLength=max(0.01, motorDist-res.framewidth/2);       
    length = minRodLength; %rodData(x(12),1)*2.54/100; %length converted to m
    
    diameter = rodData(x(12),2)*2.54/100; %diamenter converted to m
    thickness = rodData(x(13),3)*2.54/100; %thickness converted to m
    
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
