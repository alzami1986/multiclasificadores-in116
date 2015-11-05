function pool = createPoolBagging( func, m, trai, class, k )
% POOL=CREATEPOOLBAGGING(FUNC,M,TRAI,CLASS,K)
% Desc: Crea el pool empleando bagging
% Entrada
% func: clasificador
% m: numero de clasificadores
% trai: conjunto de entrenamiento
% class: etiquetas
% k: dimencion de los subconjuntos
% Salida
% pool: conjunto de modelos


[mt,nt] = size(trai);
if mt>k
error('mt>k');
end

%entrenando los m clasificadores
pool = cell(m,1);
Tis = randi([1 mt],m,k);
for i=1:m
    Ti = Tis(i,:);
    %Ti = datasample(1:mt,k);
    %Ti = randi([1 mt],1,k);
    subconjunto = trai(Ti,:); subclases = class(Ti);
    model = feval(func,subconjunto,subclases);
    pool{i} = model;
end


end

