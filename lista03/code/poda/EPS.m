function ens = EPS( pool, L, test, class, p  )


C = length(unique(class));
[M,~] = size(test);
R = zeros(M,L);
for i = 1:M %para todos los obj de entrenamiento
    for j=1:L %para todos los clasificadores
    y = predict(pool{j},test(i,:));
    R(i,j) = y;        
    end    
end

%Calculando matriz de diferencias 
mid = 2; %fix(L/C)+1;
idx = nchoosek(1:L,mid);
N = size(idx,1);
Md = zeros(M,N);
for i=1:M
    for j=1:N
    Md(i,j) = meq(R(i,idx(j,:)))&(R(i,idx(j,1)) == class(i));
    end
end



Ens = [];
W_Lij = zeros(1,N);
W_Li  = zeros(1,L);
Mk = zeros(M,1);

while true


    %Si todos los clasificadores fueron analisados
    if length(Ens) == L
        %disp('terminar')
        break;
    end
    
    %Actualizar los pesos del pool
    W_Lij = W_Lij + sum(Md,1)./M;    
    
    %Seleccionar el de maximo
    [mx,j] = max(W_Lij);
        
    %Agregar al Ens U Lij
    Lij = idx(j,:); 
    Ens = [Ens; Lij(:)];
    Ens = unique(Ens(:));
        
    %Actualizar pesos de los clasificadores
    W_Li(Ens) = W_Li(Ens) + mx;
    
    %Actualizar Md
    i = (Md(:,j)==1);
    Md(:,j) = 0; %Md_{Lij} = 0
    Md(i,:) = max(Md(:)) + 0.5; % Md(Oij)++ 
    
    
    %Actualizar las marcas
    Mk(i) = Mk(i) + 1;
    i = (Mk>(fix(L/C)+1));
    Md(i,:) = 0;
     
    
end


T = fix((p*L)/100);
[~,I] = sort(W_Li,'descend');
ens = I(1:T);


end

