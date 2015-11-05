function hc = histclass( y, class, tipo)

if nargin == 2
tipo = 'acierto'; 
end

[L,N] = size(y);
R = abs(y'-repmat(class,1,L)) == 0;

if strcmp(tipo,'error')
R = 1-R;
end

hc = zeros(L+1,1);

Nr = sum(R,2);
for j=1:N
hc(Nr(j)+1) = hc(Nr(j)+1) + 1;
end

%Normalizando
hc = hc./N;

end

