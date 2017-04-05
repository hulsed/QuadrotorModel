function sys=design_sys(battery, motor, prop, foil, rod,esc,landingskid, res)

%Mass of system       
sys.mass = 4*motor.Mass + battery.Mass+4*rod.Mass+4*prop.mass+4*esc.mass+landingskid.mass+res.mass;
    %Note: thrust required from each motor is one-fourth the total mass.
%Planform Area of system
sys.planArea=4*rod.planArea+4*motor.planArea+landingskid.planArea+res.planArea;

%Nat frequency of motor, prop and rod system.
sys.natFreqX=sqrt(rod.StiffnessX./(0.5*rod.Mass+motor.Mass+prop.mass))/(2*pi);
sys.natFreqY=sqrt(rod.StiffnessY./(0.5*rod.Mass+motor.Mass+prop.mass))/(2*pi);

%Motor Used
sys.motorNum = motor.Num;

%Cost
sys.cost=4*rod.Cost+4*motor.Cost+battery.Cost+4*prop.cost+4*esc.cost+landingskid.cost+res.cost;
%power used not including funcitonality
sys.power=res.power;

end