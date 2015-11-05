function Medida = MeasureInterraterAgreement( y, class )

[L,N] = size(y);
R = abs(y'-repmat(class,1,L)) == 0;
Medida = 0;

for j=1:N

    r = sum(R(j,:));
    Medida = Medida + r*(L-r);    

end

p = (1/(N*L))*sum(sum(R,2));
Medida = 1 - ((1/(L))*Medida)/(N*(L-1)*p*(1-p));

end

