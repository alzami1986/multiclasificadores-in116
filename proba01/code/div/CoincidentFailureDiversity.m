function  Medida = CoincidentFailureDiversity( y, class )

[L,N] = size(y);
p = histclass(y,class,'error');
i=1:L;

P0 = (p(1)<1)*(1/((1-p(1))*(L-1)));
P1 = (L-i)*p(i+1);

CFD = P0*P1;
Medida = CFD;

end

