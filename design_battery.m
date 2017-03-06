function battery = design_battery(x)
    %load appropriate data
    batteryData = csvread('batterytable.csv', 1, 1);
    
    cellnum=double(x(1));
    sConfigs=double(x(2));
    pConfigs=double(x(3));
    
    %find properties of cell
    temp = batteryData(x(1), :);
    cell.Cost = temp(1); 
    cell.Cap = temp(2) / 1000; 
    cell.C = temp(3); 
    cell.Mass = temp(4) / 1000;


    %calculate and assign properties to battery
    battery.cell = cell;
    battery.sConfigs = sConfigs; % number of serial configurations
    battery.pConfigs = pConfigs; % number of parallel configurations

    numCells = battery.sConfigs * battery.pConfigs;
    battery.Cost = battery.cell.Cost * numCells;
    battery.Mass = battery.cell.Mass * numCells;
    battery.Volt = 3.7 * battery.sConfigs; % 3.7V is nominal voltage 
    battery.Cap = battery.cell.Cap * battery.pConfigs; % total capacity is cell cap times parallel configs
    battery.C = battery.cell.C;
    battery.Imax = battery.C.*battery.Cap;
    battery.Energy = battery.Volt * battery.Cap * 3600; % Amps * voltage
    
end