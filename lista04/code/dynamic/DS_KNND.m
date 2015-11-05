function S = DS_KNND( X, Y, Y_est, Xt, Yt_est, k, Np, Npp )
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

[n,~] = size(X);
L = size(Y_est,2);
k = min(k,n);


%% Paso 1
% Crear ranking por acc
indx = knnsearch(X,Xt,'K',k);

fC = ones(1,L);
fE = ones(1,L);
for j=1:k
          
    C = find((Yt_est == Y_est(indx(j),:)));
    E = find((Y_est(indx(j),:) == Yt_est)&(Yt_est == Y(indx(j))));
    fC(C) = fC(C) + 1;
    fE(E) = fE(E) + 1;    
    
end
Acc = fE./(fC+eps);


[~,Iacc] = sort(Acc,'descend');
Iacc = Iacc(1:Np);

Dp = zeros(Np,1);
Dp(1) = 1;
for t=Np:2
Dp(t) = GeneralizedDiversity( Y_est(indx,Iacc(1:t))', Y(indx) );
end 

mx = max(Dp(2:Np));
S = Iacc(Dp>=mx);


% % % func = @DouF;
% % % Div = DiversidadeAll2(Y_est(indx,:)', Y(indx), func );
% % % Div = sum(Div)./size(Div,1);
% % % [~,Idiv] = sort(Div);
% % % Idiv = Idiv(1:Np);
% % % 
% % % 
% % % [~,Iacc] = sort(Acc(Idiv),'descend');
% % % Iacc = Iacc(1:Np);
% % % 
% % % S = Idiv(Iacc);


end

