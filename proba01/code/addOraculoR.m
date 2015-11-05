function [ h, orc ] = addOraculoR( h, X, class )




%generar el oraculo
[M,L] = size(h);
orc = randi([1 L],1,1);

%rng(1); % For reproducibility
kk = 10;
[Gi,Gc] = kmeans(X,kk);



%generar una clase
c = unique(class);
i = randi([1 length(c)],1,1);
c = c(i);

ie = (Gi==c);
h(ie,orc) = class(ie);




end

