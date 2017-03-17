function [J_ineq,J_eq]=sys_const(z)

%convert single vector into labeled vectors
zb=z(1:3);
zp=z(4:9);
zs=z(10:11);


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
for i=1:3
    if i==1
        %battery: do an exhaustive search of the possible configurations (small
        %space, little computational cost)
        [temp(i),temp1,temp11]=opt_bat(zb,zp,zs);

    elseif i==2
        %propeller: ga?
        [temp(i),temp2,temp22]=opt_prop(zb,zp,zs);
    elseif i==3
        %structure: use ga
        try
        [temp(i),temp3,temp33]=opt_struct(zb,zp,zs);
        catch error
        [temp(i),temp3,temp33]=opt_struct(zb,zp,zs);
        end
    end
end

Jb_i=temp(1);
Jp_i=temp(2);
Js_i=temp(3);


xb_opt=temp1;
xp_opt=temp2;
xs_opt=temp3;

yb_opt=temp11;
yp_opt=temp22;
ys_opt=temp33;

%constraints: shared/coupling variables z(i) must be consistent with the
%responses from the subsystems y(i). That is, the estimate for the shared
%variable given to the subsystems (and used in the sys objective calc) must
%be consistent with what actually comes out of the analyses. This was
%already calculated in the subsystem optimizations (it was the objective)

%single measure of consistency of each component (used in CO1, not CO2)
%J_i=[Jb_i, Jp_i, Js_i];

%measure of consistency of each target (used in CO2)

%battery
    %mass and cost must be less than or equal to target
    for i=1:2
            Jb(i)=-((zb(i)-yb_opt(i))./abs(zb(i)));
    end
    %energy must be must be greater than or equal to target
    Jb(3)=(zb(i)-yb_opt(i))./abs(zb(i));

%propulsion
    %mass must be equal to target (for struct constraint)
    Jp(1)=abs((zp(1)-yp_opt(1))./abs(zp(1)));
    %cost must be less than or equal to target
    Jp(2)=-(zp(2)-yp_opt(2))./abs(zp(2));
    %voltage must be less than or equal to target
    Jp(3)=-(zp(3)-yp_opt(3))./abs(zp(3));
    %current must be less than or equal to target
    Jp(4)=-(zp(4)-yp_opt(4))./abs(zp(4));
    %rpm must be less than or equal to target
    Jp(5)=-(zp(5)-yp_opt(5))./abs(zp(5));
    %diameter must be equal to target
    Jp(6)=(zp(6)-yp_opt(6))./abs(zp(6));

%structures
    %For these variables, the response only needs to be less than the
    %target--not meet it exactly.
        Js(1)=-(zs(1)-ys_opt(1))/abs(zs(1));

        Js(2)=-(zs(2)-ys_opt(2))/abs(zs(2));

J_ineq=[Jb(1),Jb(2),Jb(3),Jp(2),Jp(3), Jp(4),Jp(5), Js(1), Js(2)];
J_eq=[Jp(1), Jp(6)];


 ineq=[];
% disp(['J_i= ', num2str(J_i)])
% disp(['z=   ', num2str(z)])
% disp(['xb_loc=', num2str(xb_opt)] )
% disp(['xp_loc=', num2str(xp_opt)] )
% disp(['xs_loc=', num2str(xs_opt)] )

end