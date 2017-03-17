function [Jp_i,xp_min,yp_min]=opt_prop(zb,zp,zs)

%variable bounds
LB=[0,0.001, 0.025];
UB=[90,0.05, 1];
xp_loc0=[10,0.0127, 0.2];
numvars=length(UB);
intcon=1:numvars;

%declaring variables saved between executing optimization
%variables used to save results between objective and constraint calcs
    lastpt=[];
    myJ_p=[];
    mycp=[];
%variables representing inputs to the functions
    %yp_shar 1, the mass of the outside system
    resMass=0.3;
    yp_shar(1)=zb(1)+zs(1)+resMass;
    %yp_shar 2, diameter (a shared variable)
    yp_shar(2)=zp(6);
    
    yp_shar=yp_shar;
    zp=zp;

func=@objprop;
const=@conprop;


options=optimset('ObjectiveLimit', 0.05,'MaxIter', 100,'Display','off', 'TolFun', 0.01);
%find feasible starting point
[xp_min,Jp_i,flags,outpt]=fminsearch(@modobj,xp_loc0, options);


%options=optimoptions('fmincon', 'Display','off', 'ObjectiveLimit', 0.05,...
%'MaxIter', 100, 'Algorithm','sqp'); %,'Display','iter' );


%try
%[xp_min,Jp_i,flags,outpt]=fmincon(@objprop,xp_loc0,[],[],[],[],LB,UB,@conprop, options);
%finds the yp output and constraints for the last pt
[temp,cp_min,yp_min]=prop_objc(xp_min,zp,yp_shar);
%catch error
%Jp_i=100;
%yp_min=5*zp;
%xp_min=[0,0];
%end
for i=1:length(yp_min)
    if isnan(yp_min(i))
        yp_min(i)=10*zp(i);
    end

end



    function J_p=objprop(xp_loc)
    if ~isequal(xp_loc,lastpt)
        [myJ_p,mycp] =prop_objc(xp_loc,zp, yp_shar);
        lastpt=xp_loc;
        
    end
        J_p=myJ_p;
    end

    function [cp,ceq]=conprop(xp_loc)
    if ~isequal(xp_loc,lastpt)
        [myJ_p,mycp] =prop_objc(xp_loc,zp, yp_shar);
        lastpt=xp_loc;
        
    end
        cp=mycp;
        ceq=[];
    end
    
   function conviol=modobj(xp_loc)
         
          for i=1:length(xp_loc)
             if xp_loc(i)>UB(i)
                xp_loc(i)=UB(i);
                bndpen(i)=3;
             elseif xp_loc(i)<LB(i)  
                xp_loc(i)=LB(i);
                bndpen(i)=3;
            else
                bndpen(i)=0;
             end
          end
            [J_pmod,cpmod] =prop_objc(xp_loc,zp, yp_shar);
         for i=1:length(cpmod)
             if cpmod(i)<=0
                 viol(i)=0;
             else
                 viol(i)=cpmod(i);
             end
         end
         conviol=J_pmod+10*sum(viol)^2+sum(bndpen);
     end

end