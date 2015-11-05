function Medida = KohaviWolpertVariance( y, class )

[L,N] = size(y);
R = abs(y'-repmat(class,1,L)) == 0;
Medida = 0;

for j=1:N

    r = sum(R(j,:));
    Medida = Medida + r*(L-r);    

end

Medida = (1/(N*L*L))*Medida;

end

