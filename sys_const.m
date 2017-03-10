function J_i=sys_const(zb,zp,zs)

%this is where subsystem responses are calculated

%battery: do an exhaustive search of the possible configurations (small
%space, little computational cost)
xb_res=1;
%propeller: ga?
xp_res=1;
%structure: use fmincon
xs_res=1;

%constraints: shared/coupling variables J()_i must be consistent with the
%responses from the subsystems x()_res. That is, the estimate for the shared
%variable given to the subsystems (and used in the sys objective calc) must
%be consistent with what actually comes out of the analyses.

Jb_i=(zb-xb_res).^2;
Jp_i=(zp-xp_res).^2;
Js_i=(zs-xs_res).^2;

%creating a single vector of constraints
J_i=[Jb_i, Jp_i, Js_i];


end