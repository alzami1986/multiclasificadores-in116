function Medida = EntropyMeasure( y, class )


[L,N] = size(y);
R = abs(y'-repmat(class,1,L)) == 0;
Medida = 0;

for j=1:N

    r = sum(R(j,:));
    Medida = Medida + min(r,L-r);

end

Medida = (2/(N*(L-1)))*Medida;

end

