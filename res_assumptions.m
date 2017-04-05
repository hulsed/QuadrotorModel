function res=res_assumptions()

%electronics mass	
    transmittermass=0.0072;
    controllermass=0.028;
    powermass=0.017;
    gpsmass=0.026;
    telemetrymass=0.004;
    antennamass=0.006;
    wiremass=0.005;

electronicsmass=transmittermass+controllermass+gpsmass+telemetrymass+antennamass+wiremass;

%structural masses
    housingmass=0.01;
    framemass=0.03;
    partsmass=0.005;

structuralmass=housingmass+framemass+partsmass;

%frame dimensions
    controllerwidth=0.082;
    controllerheight=0.016;
    extrawidth=0.02;
    extraheight=0.02;

%payload
    gimbalmass=0.16;
    cameramass=0.15;
	payloadheight=0.03;

%note: with payload, the problem becomes more boring. leaving it out for
%now.
%payloadmass=gimbalmass+cameramass;
payloadmass=0;

%costs
    electronicscost=200;
    structuralcost=30;
    payloadcost=250;
    
%power use
    %power provided by module
    electronicspower=0.8+0.3+1.5+1.2+0.6;
    payloadpower=12*0.5;

%calculating residual quantities
    % "non-designed" parts of the design.
    res.mass=electronicsmass+structuralmass+payloadmass;
    
    res.framewidth=controllerwidth+extrawidth;
    res.frameheight=controllerheight+extraheight;
    
    res.planArea=res.framewidth^2;
    res.sideArea=res.framewidth*res.frameheight;
    
    res.cost=electronicscost+structuralcost+payloadcost;
    
    res.power=electronicspower+payloadpower;
	res.payloadheight=0.03;

end