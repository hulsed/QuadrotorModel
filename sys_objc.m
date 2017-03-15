function Fc=sys_objc(z)
F=sys_obj(z);
[temp,constraints]=sys_const(z);
for i=1:length(constraints)
    if constraints(i)>0.1
        conviol(i)=constraints(i);
    else
        conviol(i)=0;
    end
end
infeas=sum(conviol);


    if infeas<0.1
        penalty=0;
        Fc=F+penalty;
    elseif 0.1<=infeas<0.2
        penalty=100;
        Fc=F+penalty;
    elseif 0.2<=infeas<0.5
        penalty=1000;
        Fc=F+penalty;
    elseif 0.5<=infeas<2.0
        penalty=10000;
        Fc=F+penalty;
    elseif 2.0<=infeas<10
        penalty=100000;
        Fc=F+penalty;
    elseif 10<=infeas<20
        penalty=10e8;
        Fc=F+penalty;
    elseif 20<=infeas
        Fc=10e10;
    end

end