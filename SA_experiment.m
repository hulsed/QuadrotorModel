function [xintopt,xcopt,fopt]=sa_experiment()

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

%random initial point
for m=1:length(Intchoices)
    x_int0(m)=randi(Intchoices(m));    
end

for m=1:length(UBc)
    x_cont0(m)= LBc(m)+rand*(UBc(m)-LBc(m));
end


nint=numel(Intchoices);
ncon=numel(UBc);
nvars=nint+ncon;

UBall=[Intchoices,UBc];
LBall=[Intchoices*0+1,LBc];
x0all=[x_int0,x_cont0];

tests=10;

for i=1:tests

%options=optimoptions(@ga,'PlotFcn',@gaplotbestf)
%options=gaoptimset('PlotFcn',@gaplotbestf, 'Display', 'iter', 'Generations', 200);
soptions=saoptimset('DataType','custom','AnnealingFcn',@annealfunc,'PlotFcn',{@saplotbestf}, 'MaxIter',20000, 'TemperatureFcn', @temperatureboltz, 'ReannealInterval', 50,'Display','Iter','InitialTemperature', 5 ) 

%[x,fval,exitflag]=ga(fun,nvars,[],[],[],[],LBall,UBall,cfun,[1:nint],soptions)
[x,fval,exitflag]=simulannealbnd(@objfun,x0all,LBall,UBall,soptions)

xopt(i,:)=x;
fopt(i)=fval;

savefig(['SAResults' num2str(i)])

end

save(['SAResults_final'])


    function obj=objfun(x)
            xint=x(1:length(Intchoices));
            xcont=x((length(Intchoices)+1):length(UBall));
            
          [obj0,obj1,con]=objcfun(xint, xcont);
          
          obj=obj1+10000*con;
    end


    function [xnew] = annealfunc(values,problem);
        
        
    inttemps=values.temperature(1:length(Intchoices));
    conttemps=values.temperature((length(Intchoices)+1):length(UBall));
    
    intstepsizes=max(ones(1,length(Intchoices)), floor((Intchoices-1)/4*sqrt(inttemps)));
    contstepsizes=(UBc-LBc).*sqrt(conttemps');
    
    xnew0=values.x;
    xint_new0=xnew0(1:length(Intchoices));
    x_cont_new0=xnew0((length(Intchoices)+1):length(UBall));
    
    
    
    while 1==1 
    intdir=randi(3,1,length(Intchoices))-2;    
        
    xintnew=min(Intchoices,max(1,xint_new0+intstepsizes.*intdir));
    
    dir=rand(length(UBc),1)*2-1;
    dir=dir/sum(abs(dir));
    xcontnew=min(UBc, max(LBc, x_cont_new0+contstepsizes.*dir'));
    
    xnew=[xintnew,xcontnew];
    
    if not(all(isequal(values.x,xnew)));
       break 
    end
    end

    end


end