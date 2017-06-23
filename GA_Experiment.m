function [xintopt,xcopt,fopt]=ga_experiment()

  xLast = []; % Last place computeall was called
  myf = []; % Value of objective at xLast
  myc = []; % Value of nonlinear inequality constraint
  myceq = []; % Value of nonlinear equality constraint
  fun = @objfun; % the objective function, nested below
  cfun = @constr; % the constraint function, nested below



%declare the number of choices of each variable
% BATTERY
batteryIntChoices = [6, 7, 4];
% MOTOR
motorIntChoices = [9]; %24 in total, restricting to 9
% PROPELLER
propIntChoices = [7];%, 12, 10, 10, 10, 10];
propUB=         [0.2,   45, 1,      0.02,   1];
propLB=         [0.02,  0,  0,      0.005,  0];

% ROD
rodIntChoices=[4];

rodUB=[0.006,0.0380,0.0380];
rodLB=[0.0009,0.0065,0.0065];

% ESC
escIntChoices=[6];

% SKID
skidIntChoices=[4];

skidUB=[60,0.0380,0.006];
skidLB=[20,0.0065,0.0009];

% Oper

operUB=[30,45];
operLB=[0.1,0.1];

Intchoices=[batteryIntChoices motorIntChoices propIntChoices rodIntChoices escIntChoices skidIntChoices];

UBc=[propUB,rodUB,skidUB,operUB];
LBc=[propLB,rodLB, skidLB,operLB];


nint=numel(Intchoices);
ncon=numel(UBc);
nvars=nint+ncon;

UBall=[Intchoices,UBc];
LBall=[Intchoices*0+1,LBc];


tests=10;

for i=1:tests

%options=optimoptions(@ga,'PlotFcn',@gaplotbestf)
options=gaoptimset('PlotFcn',@gaplotbestf, 'Display', 'iter', 'Generations', 200);


[x,fval,exitflag]=ga(fun,nvars,[],[],[],[],LBall,UBall,cfun,[1:nint],options)

xopt(i,:)=x;
fopt(i)=fval;

savefig(['GAResults' num2str(i)])

end

save(['GAResults_final'])


    function y=objfun(x)
        if ~isequal(x,xLast) % Check if computation is necessary
           [y,myc,myceq] = computeall(x);
           myf = y;
           xLast = x;
      else % If no computation necessary, use existing value
           y = myf;
      end
          
    end

    function [c,eq]=constr(x)
        
        if ~isequal(x,xLast) % Check if computation is necessary
           [myf,c,ceq] = computeall(x);
           myc = c;
           myceq = ceq;
           xLast = x;
      else % If no computation necessary, use existing values
           c = myc;
           ceq = myceq;
        end
      eq=[];
        
    end

    function [f1,c1,ceq1] = computeall(x)
        
        x_int=x(1:nint);
        x_cont=x((nint+1):nvars);
        
         % "non-designed" parts of the design.
        res=res_assumptions();
        %design of subsystems
        battery = design_battery(x_int);
        motor = design_motor(x_int);
        [prop,foil] = design_prop(x_int,x_cont);
        rod = design_rod(x_int,x_cont, prop,res);
        esc = design_esc(x_int);
        landingskid=design_landingskid(x_int,x_cont,res);

        oper.climbvel=x_cont(12);
        oper.flightangle=x_cont(13);  

        %design of system
        sys=design_sys(battery, motor, prop, foil, rod,esc,landingskid, res);
        %calculate objective

        [obj1, constraints] = calc_obj(battery, motor, prop, foil, rod,esc,landingskid, sys, oper);
        
        
      ceq1 = [];
      c1 =  constraints;
      f1 =  obj1;

    end


end


