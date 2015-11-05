function Y = classRandomSubspaceSerie( pool,M, test )
% Y=CLASSRANDOMSUBSPACE(POOL,TEST)
% Desc: ensamble
% Entrada
% pool: modelos
% test: conjunto de pruba
% Salida
% Y: conjunto de etiquetas

[m,n] = size(test);
%M = length(pool);
Y = zeros(M,m);
R = zeros(m,M);

for i = 1:m %para todos los obj de entrenamiento
    
    for j=1:M %para todos los clasificadores
    y = predict(pool{j}.model,test(i,pool{j}.subspace));
    R(i,j) = y;        
    end
    
end

%regla de votacion
for i=1:M
Y(i,:) = mode(R(:,1:i),2);
end

end

