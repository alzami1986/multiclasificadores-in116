function Y = classBagging( pool, test )
% Y=CLASSBAGGING(POOL,TEST,CLASS)
% Desc: ensamble
% Entrada
% pool: modelos
% test: conjunto de pruba
% Salida
% Y: conjunto de etiquetas

[m,n] = size(test);
M = length(pool);
Y = zeros(m,1);

%clasificar
for i = 1:m 
    
    R = zeros(M,1);
    for j=1:M %para todos los clasificadores
        y = predict(pool{j},test(i,:));
        R(j) = y;        
    end
    
    %regla de votacion
    Y(i) = mode(R);    
          
end


end

