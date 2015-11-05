function Medida = Difficulty( y, class )

[L,N] = size(y);
f = histclass(y,class);
x=(0:L)./L;

E = x*f;
V = ((x-E).^2)*f;
Medida = V;

end

