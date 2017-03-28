function esc=design_esc(x)

escData=csvread('esctable.csv',1,2);

chosenEscParams=escData(x(9),:);

esc.cost=chosenEscParams(1);
esc.mass=chosenEscParams(2)/1000; %converting grams to kg
esc.maxcurrent=chosenEscParams(3);
esc.minbats=chosenEscParams(4);
esc.maxbats=chosenEscParams(5);

end