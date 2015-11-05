function ens = EPS2( pool, L, test, class, p  )


C = length(unique(class));
[M,~] = size(test);
R = zeros(M,L);
for i = 1:M %para todos los obj de entrenamiento
    for j=1:L %para todos los clasificadores
    y = predict(pool{j},test(i,:));
    R(i,j) = y;        
    end    
end


mid = 2; %fix(L/C)+1;
idx = nchoosek(1:L,mid);
N = size(idx,1);
Md = zeros(M,N);

for i=1:M
    for j=1:N
    Md(i,j) = meq(R(i,idx(j,:)))&(R(i,idx(j,1)) == class(i));
    end
end


fils = true(1,M);
cols = true(1,N);
Ens = [];
Pc = zeros(1,N);

while true


%1.Eliminar las filas = 0
ifile = searchRowCero( Md, fils, cols );
fils(ifile) = 0;
ifile = ifile&fils(:);

%2.Eliminar las columnas que suman 1
icol = searchColumnSumN( Md, fils, cols, 1 );
cols(icol) = 0;
icol = icol&cols(:);

if sum(fils) == 0 || sum(cols) == 0
%disp('terminar1')
break;
end


%2.1 Union a Ens U Lij
Lij = idx(icol,:); 
Ens = [Ens;Lij(:)];
Ens = unique(Ens(:));

%3.Calcular el peso de Lij
n = sum(cols);
P = zeros(n,1);
icol = find(cols);
for j=1:n
    
    jj = icol(j); %index
    P(j) = sum(Md(fils,jj));    
    Lij = idx(jj,:); 
    Lij = unique(Lij(:));
    P(j) = P(j) + length(intersect(Ens, Lij));

end

%4. Selecciones Lij
[pso,j] = max(P);

%4.1 Agregarlo a Ens
jj = icol(j); %index
Lij = idx(jj,:); 
Ens = [Ens;Lij(:)];
Ens = unique(Ens(:));
Pc(jj) =  pso;

%4.2 Eliminar los objetos clasificados por Lij
ii = find(Md(:,jj)==1);
fils(ii) = 0;
cols(jj) = 0;

% % if sum(fils) == 0 || sum(cols) == 0
% % disp('terminar2')
% % break;
% % end

%disp(sum(fils))

end

%ens = Ens;
%disp(L - length(ens))

%---
%calculando pesos de cada clasificador
Pesos = zeros(1,L);
for i=1:N
    iter = idx(i,:);
    Pesos(iter) = Pesos(iter) + Pc(i);    
end

T = fix((p*L)/100);
[~,I] = sort(Pesos,'descend');
ens = I(1:T);


end

