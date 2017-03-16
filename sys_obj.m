function F=sys_obj(z)

%convert single vector into labeled vectors
zb=z(1:3);
zp=z(4:9);
zs=z(10:11);

%convert notation into human language
    %zb_1 - battery mass - equality
    batteryMass=zb(1);
    %zb_2 - battery cost - inequality
    batteryCost=zb(2);
    %zp_3 - battery energy stored -inequality
    batteryEnergy=zb(3);

    %zp_1 - propulsion mass - equality
    propulsionMass=zp(1);
    %zp_2 - propulsion cost - inequality
    propulsionCost=zp(2);
    %zp_3 - propulsion voltage applied - equality
    propulsionVap=zp(3);
    %zp_4 - propulsion current applied - equality
    propulsionIap=zp(4);
    %zp_5 - propulsion rpm acheived - inequality
    propulsionRpm=zp(5);
    %zp_6 - propulsion diam -- a shared variable, not a target per se
    propulsionDiam=zp(6);

    %zs_1 - structures mass - equality
    structureMass=zs(1);
    %zs_2 - structures cost - inequality
    structureCost=zs(2);

%system-level properties
    % residual "non-designed" parts of the design.
    resMass=0.3;
    resFramewidth=0.075; %temp width of frame!
    resPlanArea=resFramewidth^2;
    resCost=50;
    resPower=5;

    %designed properties
    propulsionPower=propulsionIap*propulsionVap;
    totalPower=propulsionPower+resPower;

%calculate objectives
    flightTime=batteryEnergy/totalPower;
    totalCost=batteryCost+propulsionCost+structureCost+resCost;

    F=3*totalCost-flightTime;
  

end
