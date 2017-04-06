function [constraints]=calc_constraints(battery, motor, prop, foil, rod,esc,landingskid, sys, hover,failure)
% Constraints in a normalized form g=val/valmax-1 or g=1-val/valmin
% This means when g<0, constraint is satisfied and when g>0, constraint 
% is violated. When constraints are violated, they are multiplied by the
% penalty to create a negative reward (this works because constraint value
% is negative.)

% After typing in constraint, make sure to assign it to a component in
% compute_rewards so it can be learned.

%System Constraints
    %calcs must not fail
     c_sys(1)=failure;
     %system must acheive required thrust
     thrustReq = sys.mass*9.81/4;
     c_sys(2)=10*(1-hover.thrust/thrustReq); %Note: multiplying by 10 is arbitrary to make the magnitude larger
     tol=0.005;
     if c_sys(2)<=tol
         c_sys(2)=0;
     end
%Battery 
     %max current
     c_bat(1)=(4*hover.amps)/battery.Imax-1; %Note: perf is from EACH motor.
     %max voltage 
     c_bat(2)=hover.volts/battery.Volt-1;

%Motor Constraint
     %max current
     c_mot(1)=hover.amps/motor.Imax-1;
     %max power
     c_mot(2)=hover.pelec/motor.Pmax-1;
     %max voltage???
%Propeller Constraint (empty for now)
    
    %Stress under bending
    propmoment=hover.thrust/2*prop.diameter/2;
    propstress=propmoment*0.5*prop.thickRoot/prop.amomentRoot;
    sf=2;
    propmaxstress=prop.sy*1e6/sf;
    c_prop(1)=propstress/propmaxstress-1;
    %Deflection
    
%Rod Constraints

     %Stress

     %stiffness/natural freq (cantilever beam) (strouhal no=0.2)
     forcedFreq=hover.rpm/60; %converting to hz

     minnatFreq=2*forcedFreq; %natural frequency must be two times the forced frequency.
     % There should be more technical justification for this.
     c_rod(1)=1-sys.natFreqX/minnatFreq;
     c_rod(2)=1-sys.natFreqY/minnatFreq;

     %deflection in x direction(1% of length, max)
     maxDefl=0.01*rod.Length;
     defly=hover.thrust/rod.StiffnessX;
     c_rod(3)=defly/maxDefl-1;
     
     %stress in y direction
     sf=2;
     maxStress=rod.mat.Sy*1e6/sf; %must not reach yield stress with sf of 2.
     stressY=hover.q*0.5*rod.Width/rod.AmomentY;
     c_rod(4)=stressY/maxStress-1;
     
     %stress in x direction
     sf=2;
     maxStress=rod.mat.Sy*1e6/sf; %must not reach yield stress with sf of 2.
     stressX=hover.thrust*rod.Length*0.5*rod.Height/rod.AmomentX;
     c_rod(5)=stressX/maxStress-1;
 
 %ESC Constraints
    %more than min configs
    c_esc(1)=1-battery.sConfigs/esc.minbats;
    %less than max configs
    c_esc(2)=battery.sConfigs/esc.maxbats-1;
    %less than max current
    c_esc(3)=hover.amps/esc.maxcurrent-1;
 %Skid constraints
    fallheight=1;
    impactvel=sqrt(2*9.81*fallheight);
    skiddefl=sqrt(sys.mass/(2*landingskid.stiffness))*impactvel;
    impactforce=skiddefl*landingskid.stiffness;
    
    maxforce=200; %max force that may be transmitted through the landing skid from fall (200 N or 45 lbs)
    
    c_skid(1)=impactforce/maxforce-1;
    
    moment=impactforce*landingskid.conslength;
    stress=moment*landingskid.diameter/landingskid.Amoment;
    %c_skid(2)=stress/(landingskid.mat.Sut*1e6)-1;
    
    
    
     
 constraints=[c_sys,c_bat,c_mot,c_prop,c_rod,c_esc,c_skid];
 
 %if any aren't a number, that violates all the constraints
 if any(isnan(constraints))
     constraints=ones(1,length(constraints))*10;
 end
 
end
 
 

 
 