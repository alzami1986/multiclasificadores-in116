function S = DS_KNN( Xcv, Ycv, Ycv_est, Xtes, Ytes_est, k, Np, Npp )
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
% Crear ranking por acc
indx = knnsearch(Xcv,Xtes,'K',k);

fC = zeros(1,L);
fE = zeros(1,L);
for j=1:k
          
    C = find((Ytes_est == Ycv_est(indx(j),:)));
    E = find((Ycv_est(indx(j),:) == Ytes_est)&(Ytes_est == Ycv(indx(j))));
    fC(C) = fC(C) + 1;
    fE(E) = fE(E) + 1;    
    
end
Acc = fE./(fC+eps);

[~,Iacc] = sort(Acc,'descend');
Iacc = Iacc(1:Np);


%% Paso 2
% Crear ranking por div

func = @DouF;
Div = DiversidadeAll(Ycv_est(indx,Iacc)', Ycv(indx), func );
[~,Idiv] = sort(Div(:,1));
Idiv = Idiv(1:Npp);
S = unique(Div(Idiv,2:3));
S = Iacc(S(1:Npp));


end

