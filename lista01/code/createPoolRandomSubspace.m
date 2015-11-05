function pool = createPoolRandomSubspace( func, m, trai, class, k  )
% POOL=CREATEPOOLRANDOMSUBSPACE(FUNC,M,TRAI,CLASS,K)
% Desc: Crea el pool empleando random subspace
% Entrada
% func: clasificador
% m: numero de clasificadores
% trai: conjunto de entrenamiento
% class: etiquetas
% k: dimencion de los subespacios
% Salida
% pool: conjunto de modelos


[mt,nt] = size(trai);
if nt<k
error('nt>k')
end

%entrenar los modelos en cada subspacio
pool = cell(m,1);
for i=1:m
    Ti = datasample(1:nt,k,'Replace',false);
    subconjunto = trai(:,Ti);
    %param = 1.0;
    model = feval(func,subconjunto,class);
    pool{i}.model = model;
    pool{i}.subspace = Ti;
    
end


end

