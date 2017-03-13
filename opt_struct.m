function Js_=opt_struct(zb,zp,zs)

%variable bounds
LB=[1,1,1,1];
UB=[4,11,8,16];
numvars=length(UB);
intcon=1:numvars;

%ys_shar is passed to the nested functions
    %ys_shar 1 - Prop diameter
    ys_shar(1)=zp(8);
    %ys_shar 2 - Motor RPM
    ys_shar(2)=zp(6);
    %ys_shar 3 - propulsion mass
    ys_shar(3)=zp(1);
    %ys_shar 4 - delivered thrust
    ys_shar(4)=zp(5);
    
    ys_shar=ys_shar;



options=gaoptimset('PlotFcn',@gaplotbestf);


[xp_min,Js_,flags,outpt]=ga(@objstruct,numvars,[],[],[],[],LB,UB,@construct,intcon,options);

    function J_s=objstruct(xs_loc)
        J_s=struct_obj(xs_loc,zs);
    end

    function [cs, ceq]=construct(xs_loc)
        cs=struct_const(xs_loc, ys_shar);
        ceq=[];
    end
end