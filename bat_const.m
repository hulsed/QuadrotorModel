function cb=bat_const(xb_loc, yb_shar)

%xb_loc, the local varables for the battery
%cb, the local constraint value
%yb_shar, the estimates/targets of the responses from the other subsystems

%constructing battery from appropriate data/calcs
     battery = design_battery(xb_loc);

%converting to human-readable language
     %yb_shar1 - applied current
     Iapplied=yb_shar(1);
     %yb_shar2 - applied voltage
     Vapplied=yb_shar(2);
 
 %calculating the local constraints
 
     %cb_1 - must be capable of supplying the operational current
     cb(1)=Iapplied/battery.Imax-1;
     %cb_2 - must be capable of supplying the correct current
     cb(2)=Vapplied/battery.Volt-1;
      

end