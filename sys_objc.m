function Fc=sys_objc(z)
F=sys_obj(z);
constraints=sys_const(z);
for i=1:length(constraints)
    if constraints(i)>0.1
        conviol=constraints(i);
    else
        conviol=0;
    end
end
Fc=F+2000*sum(conviol)^2;
end