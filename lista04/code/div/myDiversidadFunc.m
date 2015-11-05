function Medida = myDiversidadFunc( y, class )


f = histclass(y,class);
L = length(f);

T = fix(L/2);
i = 1:(T+mod(L,2)); j = (T+1):L;

%crando la funcion de pesos 
beta = 1; alpha = 2;
w = zeros(L,1);
w(i) = -beta;
w(j) = (L-j+1)*alpha/L;

M = f'*w;

%figure(1);bar(f);M
Medida = M;


end

