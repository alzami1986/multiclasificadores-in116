function y_rec = REC( DP, y, C )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[M,L] = size(DP);
y_rec = zeros(M,1);

% numclass = tabulate(y); 
% numclass = numclass(:,2);


%prob de cada clasificador
p = zeros(C,L);
for i = 1:L
   
    cm = getCM( y, DP(:,i), C );     
    p(:,i) = diag(cm)./sum(cm,1)';   
    
end


%prob a priori
prior = zeros(C,1);
for i=1:C
prior(i) = sum(DP(:)==i)/(M*L);
end



for i=1:M

%ecuacion 15. [kuncheva,Juan]
%log(P(w_k|s)) prop:= log(P(w_k)) + sum_{iEI+^k}w_i + |I+^k|*log(c-1)

g = zeros(C,1);
for j=1:C
d = (DP(i,:) == j);
g(j) = log(prior(j)) + sum(log(1-p(j,:))) ...
    + sum( d.*log(p(j,:)./(1-p(j,:))) ) + sum(d)*log(C-1);  
end

[iw,w] = max(g);
y_rec(i) = w;


end




end

