function flight=calc_flight(sys,flightangle)

phi = flightangle *pi/180;
cd=1.5;     % assumed coefficent of drag (quadrotor is a blunt object)
rho=1.225;   % kg/m^3, density of air

thrustTot=sys.mass*9.81/(cos(phi));
thrustReq=thrustTot/4;


%specified inputs to qprop:



end
