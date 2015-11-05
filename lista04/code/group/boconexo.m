%--------------------------------------------------------------------------
%FUNCI�N PARA FORMAR GRUPOS
%--------------------------------------------------------------------------
function [G,C] = boconexo(O,Bo,dist,varargin)
%[G,C]=BOCONEXO(O,CARACT,BO,DIST)
%
%
% Entrada:
%   O   colecci�n de objetos con p rasgos
%   Bo  menor valor de semejanza entre los objetos, este debe estar entre
%       cero y uno
%   dist   distancia entre objetos
%
% Salida
%   G   grupos beta cero conexos
%       Sea n la cantidad de objetos de O. G es un vector tal que: el
%       �ndice i representa el objeto i-�simo y G(i) el grupo al que
%       pertenece
%
%   C   cantidad de componentes conexas
%

%--------------------------------------------------------------------------

[n,p] = size(O);
outClass = class(O);

% Inicializando el vector de grupo
G = zeros(1,n);

%--------------------------------------------------------------------------
% M�TODO

for i=1:(n-1)

    Y = zeros(1,n-i+1); % fila actual de semejanza entre objetos
    %----------------------------------------------------------------------
    % 1 C�LCULO DE LA DISTANCIA
    % Funci�n de semejanza entre objetos

    switch(dist)

        case 'euc'
            
            dsq = zeros(n-i,1,outClass);
            for q = 1:p
                dsq = dsq + (O(i,q) - O((i+1):n,q)).^2;
            end
            Y(2:end) = sqrt(dsq)./max(dsq);            
            Y = (Y<Bo).*Y;
             
        
        case 'cosine' 
                    
            d = zeros(n-i,1,outClass);
            for q = 1:p
                d = d + (O(i,q).*O((i+1):n,q));
            end
            d(d>1) = 1; % protect against round-off, don't overwrite NaNs
            Y(2:end) = d;
            Y = (Y>Bo).*Y;

    end


    %----------------------------------------------------------------------
    % 3 BUSCANDO LOS B0-SEMEJANTES
    % Se buscan las posiciones en y que sean distintas de cero
    j = find(Y(:));

    if G(i) == 0 %no esta mark
        G(i)=i;      %formar un nuevo grupo
    end

    %----------------------------------------------------------------------
    % 4 AN�LISIS DE LA CASU�STICA

    %Chequeando que el objeto i-�simo sea bo-semejante a alg�n otro objeto
    %en caso de no serlo este formar� un grupo degenerado
    if ~isempty(j)

        j = j+(i-1);%reajuste de las coordenadas

        jnz = find(G(j));
        jz  = find(~G(j));

        if ~isempty(jz) %si no est� marcado
            jz = j(jz);
            G(jz) = G(i);
        end

        if ~isempty(jnz)

            % Se unir�n todos los grupos presentes en
            % G(j) con los de G(i) y el representante
            % ser� el menor de todos
            % UNIR(G(i),G(j));

            jnz  = j(jnz);
            grup = unique(G(jnz));

            for k=1:length(grup)
                G(G==grup(k))=G(i);
            end

        end

    end % fin de la condici�n de Bo semejanza



end



%--------------------------------------------------------------------------
% FIN DEL M�TODO
% 5 AN�LISIS DEL �LTIMO CASO
% ...
if G(n) == 0 % no est� marcado
G(n)= n;     %formar un nuevo grupo degenerado
end


% 6 FORMAR GRUPOS
% Organizamos los  grupos de manera tal que exista una correspodencia con
% el eje num�rico

S = G;
S = unique(S);
C = length(S);

for i =1:C
    G(G==S(i)) = i;
end


end
