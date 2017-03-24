function [constraints]=calc_constraints(battery, motor, prop, foil, rod,esc,sys, hover,failure)
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
    c_prop(1)=0;
    %Stress under bending
    %Deflection
    
%Rod Constraints

     %Stress

     %stiffness/natural freq (cantilever beam) (strouhal no=0.2)
     forcedFreq=hover.rpm/60; %converting to hz

     minnatFreq=2*forcedFreq; %natural frequency must be two times the forced frequency.
     % There should be more technical justification for this.
     c_rod(1)=1-sys.natFreq/minnatFreq;

     %deflection (1% of length, max)
     maxDefl=0.01*rod.Length;
     defl=hover.thrust/rod.Stiffness;
     c_rod(2)=defl/maxDefl-1;
     %impact
 
 %ESC Constraints
    %more than min configs
    c_esc(1)=1-battery.sConfigs/esc.minbats;
    %less than max configs
    c_esc(2)=battery.sConfigs/esc.maxbats-1;
    %less than max current
    c_esc(3)=hover.amps/esc.maxcurrent-1;
     
 constraints=[c_sys,c_bat,c_mot,c_prop,c_rod,c_esc];
 
 %if any aren't a number, that violates all the constraints
 if any(isnan(constraints))
     constraints=ones(1,length(constraints))*10;
 end
 
end
 
 

 
 