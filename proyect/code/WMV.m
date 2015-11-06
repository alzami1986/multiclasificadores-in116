function y_wmv = WMV( DP, y, C )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[M,L] = size(DP);
y_wmv = zeros(M,1);

%prob de cada clasificador
p = zeros(L,1);
for i = 1:L
    %CM = getCM( y, DP(:,i), C );
    %p(i) = trace(CM)/sum(CM(:));
    p(i) = mean(double(DP(:,i) == y));        
end





%prob a priori
prior = zeros(C,1);
for i=1:C
prior(i) = sum(DP(:)==i)/(M*L);
end



for i=1:M

% d = zeros(L,C);
% d( ((1:L)-1).*C + DP(i,:)) = 1;


%ecuacion 4.47
%g_j(x) = log(P(w_j)) + sum_{i=1}^L d_{i,j} log(p_i/(1-p_i))
g = zeros(C,1);
for j=1:C
d = (DP(i,:) == j);
g(j) = log(prior(j)) +  sum( d(:).*log(p./(1-p)) ) + sum(d)*log(C-1)  ; % + sum(d(:,j))*log(C-1) d(:,j) 
end

[~,w] = max(g);
y_wmv(i) = w;


end




end

