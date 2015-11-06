function y_nb = NB( DP, y, C )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

[M,L] = size(DP);
y_nb = zeros(M,1);

%prob de cada clasificador
%p = zeros(L,1);
cm = zeros(C,C,L);
for i = 1:L
    
    tcm = getCM( y, DP(:,i), C );
    cm(:,:,i) = tcm./M;
    
    %p(i) = trace(CM)/sum(CM(:));
    %p(i) = mean(double(DP(:,i) == y));       
    
end


%prob a priori
prior = zeros(C,1);
for i=1:C
prior(i) = sum(DP(:)==i)/(M*L);
end



for i=1:M


%ecuacion 4.47
%
u = zeros(C,1);
for j=1:C
si = DP(i,:);
pijk = cm(j,si,:); pijk = pijk(:);
u(j) = log(prior(j)) + sum( log(pijk) );
end

[~,w] = max(u);
y_nb(i) = w;


end

end

