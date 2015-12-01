function [ g ] = getWeightsOfErrorSpareceVectorDn( D, y, alfas, clases )
%getWeightsOfErrorSpareceVectorDn 
%D diccionario
%y señales a representar
%alfas 
%clases 
%


%Datos de entrada
[m,n] = size(alfas);
ndicc = fix(size(D,2)/n);

%Obtener las particiones 
num_c = length(clases);
soport = repelem(1:num_c,clases);
g = zeros(num_c,n);


for j = 1:n

    
    init = (j-1)*(ndicc) + 1;
    fin  = init + ndicc - 1; 
    jj = init:fin;
    
    %Para todas las clases
    for i=1:num_c

        indx = (soport == i);
        alfa_c = zeros(m,1);
        alfa_c(indx,:) = alfas(indx,j); 
        
        %Ecuacion 
        %||g_j(x) - D_id_j(alpha_i)||_2        
        y_aprox = D(:,jj)*alfa_c;
        g(i,j) = sum((y(:,j) - y_aprox).^2).^0.5; 

    end
    
end

%
%Output soft
for i=1:n
g(:,i) = 1 - g(:,i) ./ sum(g(:,i));
end

%Prob posteriori
g = exp(g);  E = sum(g,1);
for i=1:n
g(:,i) = g(:,i) ./ E(i);
end

% % % figure;
% % % hold on
% % % h = stem(g(:,1)); set(h,'MarkerFaceColor','blue')
% % % h = stem(g(:,2)); set(h,'MarkerFaceColor','red')
% % % hold off


end

