function  Medida = GeneralizedDiversity( y, class )

[L,N] = size(y);
p = histclass(y,class,'error')';
i=1:L;

P1 = sum(i.*(i-1).*p(i+1)); 
P2 = sum(i.*p(i+1));

GD = 1 - (1/(L-1))*P1/P2;
Medida = GD;

end

