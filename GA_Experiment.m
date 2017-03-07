% GA Code
% BATTERY
batteryChoices = [6, 6, 4];
% MOTOR
motorChoices = [24];
% PROPELLER
propChoices = [7, 12, 10, 10, 15, 15];
% ROD
rodChoices=[4,11,8];
numChoices = numel([batteryChoices motorChoices propChoices rodChoices]);


ObjectiveFunction = @objcfun;
nvars = numChoices;    % Number of variables
LB = ones(1,numChoices);   % Lower bound
UB = [batteryChoices motorChoices propChoices rodChoices];  % Upper bound
ConstraintFunction = @constfun;
IntCon=1:numChoices;

options = gaoptimset('PlotFcn', @gaplotbestf);
[x,fval] = ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB, ...
    [],IntCon,options)

