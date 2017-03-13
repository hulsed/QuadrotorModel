function Jp_i=opt_prop(zb,zp,zs)

%variable bounds
LB=[1,  1,  1,  1,  1,  1,  1];
UB=[24, 7,  12, 10, 10, 15, 15];
numvars=length(UB);
intcon=1:numvars;

%declaring variables saved between executing optimization
%variables used to save results between objective and constraint calcs
    lastpt=[];
    myJ_p=[];
    mycp=[];
%variables representing inputs to the functions
    %yp_shar 1, the mass of the outside system
    yp_shar(1)=zb(1)+zs(1);
    
    yp_shar=yp_shar;
    zp=zp;

func=@objprop;
const=@conprop;

options=gaoptimset('PlotFcn',@gaplotbestf,'Generations', 40, 'StallTimeLimit', 10, 'PopulationSize', 15);

%poolobj=gcp;

%updateAttachedFiles(poolobj);

[xp_min,Jp_i,flags,outpt]=ga(@objprop,numvars,[],[],[],[],LB,UB,@conprop,intcon,options);


    function J_p=objprop(xp_loc)
    if ~isequal(xp_loc,lastpt)
        [myJ_p,mycp] =prop_objc(xp_loc,zp, yp_shar);
        lastpt=xp_loc;
        
%        updateAttachedFiles(poolobj);
    end
        J_p=myJ_p;
    end

    function [cp,ceq]=conprop(xp_loc)
    if ~isequal(xp_loc,lastpt)
        [myJ_p,mycp] =prop_objc(xp_loc,zp, yp_shar);
        lastpt=xp_loc;
        
%        updateAttachedFiles(poolobj);
    end
        cp=mycp;
        ceq=[];
    end

end