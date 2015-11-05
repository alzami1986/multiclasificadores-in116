function S = OLA( Xcv, Ycv, Ycv_est, Xtes, Ytes_est, k )
%
% Entrada:
% X- objetos de la base de seleçãm nxm
% Y- clases 1xn
% Y_est - clases estimadas por cada clasificador del pool nxl
% Xt - objeto de test
% Yt_est
% k - parametro del NN
% 
%

[n,~] = size(Xcv);
L = size(Ycv_est,2);
k = min(k,n);


%% Paso 1
% Submete o padrao desconhecido a todos os classificadores, se eles 
% concordarem, retorna a resposta

if range(Ytes_est) == 0
    S = 1;
    return;
end

%% Paso 2
% Caso contr´ario, calcula o % dos exemplos corretamente classificados em 
% uma regiao local pr´oxima ao padrao desconhecido

% KNN
% % dists = sum((X-repmat(Xt,n,1)).^2,2).^0.5;
% % [~,indx] = sort(dists);
% % indx = indx(1:k);

indx = knnsearch(Xcv,Xtes,'K',k);
fC = zeros(1,L);

for j=1:k 
C = find(Ycv_est(indx(j),:) == Ycv(indx(j)));
fC(C) = fC(C) + 1;
end

fC = fC./k;

%% Seleccion
%DESCOLA-Eliminate
[mx, S] = max(fC);
%S = (fC == mx);


% % % %DESCOLA-Union
% % % S = (fC ~= 0);


end

