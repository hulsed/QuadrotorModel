function rod = design_rod(x_int,x_cont, prop, res)
    
    %reading appropriate data   
    matData=csvread('materialtable.csv',1,1);

    %thicknesses converted from inches to meters
    %thicknesses=[0.0350, 0.0580, 0.0650, 0.0830, 0.0950, 0.1250, 0.1875,  0.2500]*2.54/100;
    %widths
    %widths=[0.2500, 0.3750, 0.5000, 0.6250, 0.7500, 0.8750, 1.0000, 1.1250, 1.2500, 1.3750, 1.5000]*2.54/100;
    %heights
    %heights=[0.2500, 0.3750, 0.5000, 0.6250, 0.7500, 0.8750, 1.0000, 1.1250, 1.2500, 1.3750, 1.5000]*2.54/100;
    
    mat.Type=double(x_int(6));
    mat.Ymod=matData(x_int(6),1); %young's modulus in GPa
    mat.Sut=matData(x_int(6),2); %ultimate strength in MPa
    mat.Sy=matData(x_int(6),3); %yield strength in MPa
    mat.Dens=matData(x_int(6),4); %density in kg/m^3
    mat.Cost=matData(x_int(6),5)*(100/2.54)^3; %cost in $/m^3
    
    
    sepDist=0.25*prop.diameter+prop.diameter;
    motorDist=sepDist/sqrt(2);
    
    minRodLength=max(0.01, motorDist-res.framewidth/2);       
    length = minRodLength; %rodData(x(12),1)*2.54/100; %length converted to m
    
    %thickness = thicknesses(x_int(7));
    %width = widths(x_int(8));
    %height=heights(x_int(9));
    thickness=x_cont(6);
    width=x_cont(7);
    height=x_cont(8);
    
    % Create the rod given everything we need
    rod.mat = mat;
    rod.Length = length;
    rod.Width=width;
    rod.Height=height;
    rod.Thick = thickness;
    innerwidth=(width-2*thickness);
    innerheight=(height-2*thickness);
    rod.Area=width*height-innerwidth*innerheight;
    
    rod.AmomentX=(1/12)*width*height.^3-(1/12)*innerwidth*innerheight.^3;
    rod.AmomentY=(1/12)*width^3*height-(1/12)*innerwidth^3*innerheight;
    
    rod.StiffnessX=(rod.Length^3/(3*rod.AmomentX*1e9*rod.mat.Ymod))^-1;
    rod.StiffnessY=(rod.Length^3/(3*rod.AmomentY*1e9*rod.mat.Ymod))^-1;
    rod.Vol=rod.Length*rod.Area;
    rod.Mass=rod.Vol*rod.mat.Dens; % in kg
    rod.Cost=rod.mat.Cost*rod.Vol;
    rod.planArea=rod.Length*rod.Width;
end
