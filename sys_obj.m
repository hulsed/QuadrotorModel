function F=sys_obj(zb,zp,zs)
%convert notation into human language
    %zb_1 - battery mass
    batteryMass=zb(1);
    %zb_2 - battery cost
    batteryCost=zb(2);
    %zb_3 - battery voltage allowed
    batteryVal=zb(3);
    %zp_4 - battery energy stored
    batteryEnergy=zb(4);

    %zp_1 - propulsion mass
    propulsionMass=zp(1);
    %zp_2 - propulsion cost
    propulsionCost=zp(2);
    %zp_3 - propulsion voltage applied
    propulsionVap=zp(3);
    %zp_4 - propulsion current applied
    propulsionIap=zp(4);
    %zp_5 - propulsion thrust acheived
    propulsionThrust=zp(5);
    %zp_6 - propulsion rpm acheived
    propulsionRpm=zp(6);
    %zp_7 - propulsion power used
    propulsionPower=zp(7);
    %zp_7 - propulsion diam
    propulsionDiam=zp(8);

    %zs_1 - structures mass
    structureMass=zs(1);
    %zs_2 - structures cost
    structureCost=zs(2);

%system-level properties
    % residual "non-designed" parts of the design.
    resMass=0.3;
    resFramewidth=0.075; %temp width of frame!
    resPlanArea=res.framewidth^2;
    resCost=50;
    resPower=5;

    %designed properties
    totalPower=propulsionPower+resPower;

%calculate objectives
    flightTime=batteryEnergy/totalPower;
    totalCost=batteryCost+propulsionCost+structureCost+rescost;

    F=3*totalCost-flighttime
  

end
