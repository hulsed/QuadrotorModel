function mission=calc_mission(sys,hover,climb, flight)

%height the quadrotor must fly to/at
flightheight=30;
%distance between POIs the quadrotor must visit
stoplength=30;
%time the quadrotor stops at each POI.
stoptime=60;
%"value" of each POI (in $)
POIval=100;
% operational cost (per second)
opercost=40/3600;

mission.climbtime=flightheight/climb.velocity;
mission.climbenergy=(4*climb.pelec+sys.power)*mission.climbtime;
mission.descendtime=mission.climbtime;
mission.descendenergy=(4*hover.pelec+sys.power)*mission.climbtime;

mission.usefulenergy=sys.energy-(mission.climbenergy+mission.descendenergy);

%calculating energy used to travel between each POI and observe
hoverenergy=(4*hover.pelec+sys.power)*stoptime;
flighttime=stoplength/flight.xvel;
flightenergy=(4*hover.pelec+sys.power)*flighttime;
mission.POIenergy=hoverenergy+flightenergy;

%number of POIs that can be observed
mission.POIs=mission.POIenergy/mission.usefulenergy;
mission.time=mission.climbtime+mission.descendtime+mission.POIs*(flighttime+stoptime);

mission.value=mission.POIs*POIval-mission.time*opercost;


end