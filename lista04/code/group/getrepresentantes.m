%--------------------------------------------------------------------------
%FUNCIÓN QUE CALCULA EL REPRESENTANTE DE UN CONJUNTO B0CONEXO
%--------------------------------------------------------------------------
function [C] = getrepresentantes(X, Bo, varargin)
%[C]=VGETREPRESENTANTES(X,BO,CARACT)
%
% El representante de un conjunto X de características es un subconjunto
% minimal C de X que satisface que:
%  *Todo elemento próximo o semejante a X lo es también a C a partir de una 
%   función B de proximidad o semejanza.
%  *El representante del conjunto unitario es él mismo
%
%

%Inicialización
outClass = class(X);
[n,p]  = size(X);
SG	   = zeros(1,n); 

% El representante del conjunto unitario es él mismo
if n<2
C = X; return;
end


% Obteniendo el valor de epsilon
Eps = varargin{1};


C(1,:) = mean([X(1,:);X(2,:)]);
SG([1 2]) = 1;
m  = 1;

for i=3:n
    
    
    dsq = zeros(m,1,outClass);
    for q = 1:p
    dsq = dsq + (abs(C(1:m,q) - X(i,q)) <= Eps);
    end
    
    Y = sqrt(dsq);
    Y = (Y>Bo).*Y;     
    [E,s] = max(Y);
    
    if E ~= 0
        
        SG(i) = s;
        ic = (SG == s); % Recalculando el centroide cs ...
        C(s,:) = mean(X(ic,:));
        
    else
        
        m = m+1;
        C(m,:) = X(i,:);
        SG(i) = m;
        
    end
    
    
end



