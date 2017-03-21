function [Js_i,xs_min,ys_min]=opt_struct(zb,zp,zs)

    %xp_loc 1 - material 
    %xp_loc 2 - diameter
    %xp_loc 3 - thickness

    pen=100;
    min_obj=inf;

%variable bounds
LB=[1,1,1];
UB=[4,11,8];
numvars=length(UB);
intcon=1:numvars;

%ys_shar is passed to the nested functions
    %ys_shar 1 - Prop diameter
    ys_shar(1)=zp(6);
    %ys_shar 2 - Motor RPM
    ys_shar(2)=zp(5);
    %ys_shar 3 - propulsion mass
    ys_shar(3)=zp(1);
    %ys_shar 4 - outside system mass
    resMass=0.3;
    ys_shar(4)=zb(1)+zp(1)+resMass;
    
    ys_shar=ys_shar;

%exhaustively search the space
for i=LB(1):UB(1)
    for j=LB(2):UB(2)
        for k=LB(3):UB(3)
            xs_loc=[i,j,k];
            [J_s,ys]=struct_obj(xs_loc,zs, ys_shar);
            cs= struct_const(xs_loc, ys_shar);
          %calculate violation
          for m=1:length(cs)
              if cs(m)>0
                  conviol(m)=cs(m);
              else
                  conviol(m)=0;
              end
          end
          obj=J_s+pen*sum(conviol)^2;
          
          if obj<min_obj
              min_obj=obj;
              xs_min=xs_loc;
              ys_min=ys;
              Js_i=J_s;
          end
            
        end
    end
   
    
end

end