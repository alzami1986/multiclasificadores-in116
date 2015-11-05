function Y = evaluatePool( pool, M, test, indx )
% Y=EVALUATEPOOL(POOL,TEST,CLASS)
% Desc: ensamble
% Entrada
% pool: modelos
% test: conjunto de pruba
% Salida
% Y: conjunto de etiquetas

if nargin < 4
indx = 1:M;
end

[m,~] = size(test);
Y = zeros(M,1);
R = zeros(m,M);

for i = 1:m %para todos los obj de entrenamiento
    
    for j=1:M %para todos los clasificadores
    y = predict(pool{indx(j)},test(i,:));
    R(i,j) = y;        
    end
    
end

% % % % %regla de votacion
% % % % for i=1:M
% % % % Y(i,:) = mode(R(:,1:i),2);
% % % % end

%Y = mode(R,2);

Y = R;


end

