function [J_i,eq]=sys_const(z)

%convert single vector into labeled vectors
zb=z(1:4);
zp=z(5:12);
zs=z(13:14);


% for j=1:25
%     poolobj=gcp;
%     filetoadd=['motorfiles/motorfile' num2str(j-1)];
%     addAttachedFiles(poolobj, {filetoadd});
%     %clear filetoadd
% end
% addAttachedFiles(poolobj, {'motorfile','propfile','qprop.exe'});
% addAttachedFiles(poolobj, {'airfoiltable.csv','batterytable.csv','materialtable.csv','motortable.csv','propranges.csv','rodtable.csv'});

%initialize variables to parfor loop (so they stay in the workspace).


%this is where subsystem responses are calculated
parfor i=1:3
    if i==1
        %battery: do an exhaustive search of the possible configurations (small
        %space, little computational cost)
        temp(i)=opt_bat(zb,zp,zs)

    elseif i==2
        %propeller: ga?
        temp(i)=opt_prop(zb,zp,zs)
    elseif i==3
        %structure: use ga
        temp(i)=opt_struct(zb,zp,zs)
    end
end

Jb_i=temp(1);
Jp_i=temp(2);
Js_i=temp(3);
%constraints: shared/coupling variables J()_i must be consistent with the
%responses from the subsystems x()_res. That is, the estimate for the shared
%variable given to the subsystems (and used in the sys objective calc) must
%be consistent with what actually comes out of the analyses. This was
%already calculated in the subsystem optimizations (it was the objective)

%creating a single vector of constraints
J_i=[Jb_i, Jp_i, Js_i];
eq=[];

end