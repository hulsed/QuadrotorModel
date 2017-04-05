function landingskid=design_landingskid(x_int,x_cont,res)

    %reading appropriate data   
    matData=csvread('materialtable.csv',1,1);
    
    mat.Type=double(x_int(8));
    mat.Ymod=matData(x_int(8),1); %young's modulus in GPa
    mat.Sut=matData(x_int(8),2); %ultimate strength in MPa
    mat.Sy=matData(x_int(8),3); %yield strength in MPa
    mat.Dens=matData(x_int(8),4); %density in kg/m^3
    mat.Cost=matData(x_int(8),5)*(100/2.54)^3; %cost in $/m^3

    buffer=0.02;
    height=res.payloadheight+buffer;
    
    theta=x_cont(9);
    diameter=x_cont(10);
    thickness=x_cont(11);
    
    xdist=height/tan((90-theta)*pi/180);
    ydist=xdist;
    
    leglength=sqrt(height.^1+xdist^2+ydist^2);
    landingskid.footlength=res.framewidth+2*xdist;
    toplength=res.framewidth;
    
    landingskid.diameter=diameter;
    landingskid.thickness=thickness;
    landingskid.theta=theta;
    landingskid.mat=mat;
    landingskid.totallength=4*leglength+2*toplength+2*landingskid.footlength;
    landingskid.area=pi/2*(diameter)^2-pi/2*(diameter-thickness)^2;
    landingskid.volume=landingskid.area*landingskid.totallength;
    landingskid.cost=landingskid.volume*mat.Cost;
    landingskid.mass=landingskid.volume*mat.Dens;
    landingskid.planArea=2*diameter*leglength;
    
    landingskid.Amoment=(pi/4)*((diameter/2)^4-(diameter/2-thickness)^4);
    landingskid.conslength=xdist;
    landingskid.stiffness=2*((landingskid.conslength^3/(3*landingskid.Amoment*1e9*mat.Ymod))^-1);
     
    

end