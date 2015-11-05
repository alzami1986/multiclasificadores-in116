function S = DSBo( Xcv, Ycv, Ycv_est, Gi, Gc, Xtes, Ytes_est, Np, Npp)



[n,~] = size(Xcv);
L = size(Ycv_est,2);
%k = min(k,n);

%% Paso 1
Glabel = Gc(:,end);
Gc = Gc(:, 1:(end-1));
dists = sum((Gc-repmat(Xtes,size(Gc,1),1)).^2,2).^0.5;

[~,imin] = min(dists);
indx = find(Gi == Glabel(imin));
k = length(indx);

%% Paso 2
% Crear ranking por acc
fC = ones(1,L);
fE = ones(1,L);
for j=1:k
          
    C = find((Ytes_est == Ycv_est(indx(j),:)));
    E = find((Ycv_est(indx(j),:) == Ytes_est)&(Ytes_est == Ycv(indx(j))));
    fC(C) = fC(C) + 1;
    fE(E) = fE(E) + 1;    
    
end
Acc = fE./fC;

[~,Iacc] = sort(Acc,'descend');
Iacc = Iacc(1:Np);


%% Paso 3
% Crear ranking por div

func = @DouF;
Div = DiversidadeAll(Ycv_est(indx,Iacc)', Ycv(indx), func );
[~,Idiv] = sort(Div(:,1));
Idiv = Idiv(1:Npp);
S = unique(Div(Idiv,2:3));
S = Iacc(S(1:Npp));



end

