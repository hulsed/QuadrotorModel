function [Jb_i,xb_min]=opt_bat(zb,zp,zs)

%bounds [6,6,4]
UB=[6,6,4];
%penalty -- an incredibly large penalty finds constrained mins only
% doesn't get caught in infeasible mins if feasible mins exist.
pen=1000000000000;

%yb_shar1 - applied current = current applied by propulsion + residual
yb_shar(1)= zp(4); %Note: how do you add the "residual" here?
%yb_shar2 - applied voltage = voltage applied by propulsion + residual
yb_shar(2)= zp(3);

%perform exhaustive search of the space (low dimensionality + cheap
%computation)
min_obj=inf;
for i=1:UB(1)
   for j=1:UB(2)
      for k=1:UB(3)
          %checked design point
          xb_loc=[i,j,k];
          %objective J_b (acheieve consistency with target)
          J_b=bat_obj(xb_loc,zb);
          %local constraint
          cb=bat_const(xb_loc, yb_shar);
          
          %calculate violation
          for m=1:length(cb)
              if cb(m)>0
                  conviol(m)=cb(m);
              else
                  conviol(m)=0;
              end
          end
          
          obj=J_b+pen*sum(conviol)^2;
          
          if obj<min_obj
              min_obj=obj;
              xb_min=xb_loc;
              Jb_i=J_b;
          end
                    
      end
   end    
end

end