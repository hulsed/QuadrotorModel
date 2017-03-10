function rod = design_rod(xs_loc)
    
    %reading appropriate data   
    rodData= csvread('rodtable.csv',1,0);
    matData=csvread('materialtable.csv',1,1);
    
    mat.Type=xs_loc(1);
    mat.Ymod=matData(xs_loc(1),1); %young's modulus in GPa
    mat.Sut=matData(xs_loc(1),2); %ultimate strength in MPa
    mat.Sy=matData(xs_loc(1),3); %yield strength in MPa
    mat.Dens=matData(xs_loc(1),4); %density in kg/m^3
    mat.Cost=matData(xs_loc(1),5)*(100/2.54)^3; %cost in $/m^3 
    
    
    
    diameter = rodData(xs_loc(2),2)*2.54/100; %diamenter converted to m
    thickness = rodData(xs_loc(3),3)*2.54/100; %thickness converted to m
    length = rodData(xs_loc(4),1)*2.54/100; %length converted to m
    
    
    
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
