function flight=calc_flight(sys,flightangle)

phi = flightangle *pi/180;
cd=1.5;     % assumed coefficent of drag (quadrotor is a blunt object)
rho=1.225;   % kg/m^3, density of air

thrustTot=sys.mass*9.81/(cos(phi));
thrustReq=thrustTot/4;

xvel=sqrt(thrustTot*sin(phi)/(0.5*cd*rho*sys.planArea));

vel=xvel*sin(phi); 
%note: while planform area in reality changes as a function of phi, the
%model does not take this into account for simplicity

%specified inputs to qprop:
%specified inputs to qprop:
    if vel==0
        velStr='0.0';
    else
        velStr=num2str(vel);       %velocity (m/s)
    end
    if thrustReq==0
        thrustStr='0.0';
    else
        thrustStr=num2str(thrustReq);
    end
mode='singlepoint'; % specify singlepoint or multipoint runs

%qprop inputs left open:
rpmStr='0';         %rpm
voltStr='0';        % voltage
dBetaStr='0';       %Dbeta, the pitch-change angle (for adjustable pitch motors)
torqueStr='0';      %Torque (N-m)
ampsStr='0';        %Amps (A)
peleStr='0';        %Electrical Power Used

flight=call_qprop(velStr, rpmStr, voltStr, dBetaStr, thrustStr, torqueStr, ampsStr, peleStr, mode, sys.motorNum);


if flight.thrust<0.9*thrustReq
flight.failure=1;  
else
flight.failure=0;   
end

if isnan(flight.pelec)
    flight.pelec=10e9;
end

flight.xvel=xvel;


end