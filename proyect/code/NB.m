function y_nb = NB( DP, y, C )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

[M,L] = size(DP);
y_nb = zeros(M,1);
numclass = tabulate(y); 
numclass = numclass(:,2);


%prob de cada clasificador
cm = zeros(C,C,L);
for i = 1:L
   
    tcm = getCM( y, DP(:,i), C );     
    cm(:,:,i) = tcm;   
    
end
cm = cm./repmat(numclass,1,C,L);

%prob a priori
prior = zeros(C,1);
for i=1:C
prior(i) = sum(DP(:)==i)/(M*L);
end


for i=1:M

%ecuacion 20. (pag. 6) [kuncheva,Juan]
% log(P(w_k|s)) prop:= log(P(w_k)) + sum_{i=1}^{L} log(p_{i,s_i,k}) 

u = zeros(C,1);
for j=1:C

    
    si = DP(i,:); si = si(:);
    k = j*ones(L,1);
    pijk = zeros(L,1);
    for l=1:L
    pijk(l) = cm(k(l),si(l),l); 
    end
    
    %Kuncheva and Juan
    u(j) = log(prior(j)) + sum( log(pijk) );
    %u(j) = log(prior(j)) +   log(prod(pijk));
    
% %     %Kuncheva
% %     Nk = sum(double(y==j)); 
% %     u(j) = (Nk/M)*(prod((pijk + 1/C)/(Nk+1)));
    
end

[iw,w] = max(u);
y_nb(i) = w;


end

end

