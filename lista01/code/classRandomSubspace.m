function Y = classRandomSubspace( pool,M, test )
% Y=CLASSRANDOMSUBSPACE(POOL,TEST)
% Desc: ensamble
% Entrada
% pool: modelos
% test: conjunto de pruba
% Salida
% Y: conjunto de etiquetas

[m,n] = size(test);
%M = length(pool);
Y = zeros(m,1);

for i = 1:m %para todos los obj de entrenamiento
    
    R = zeros(M,1);
    for j=1:M %para todos los clasificadores
        y = predict(pool{j}.model,test(i,pool{j}.subspace));
        R(j) = y;        
    end
    
    %regla de votacion
    Y(i) = mode(R);    
          
end



end

