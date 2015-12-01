function [ prior, p ] = estimateParam( models, Xtrai, Ytrai, Ycv, C, L )


%predict
DP = predictAll( models, L, Xtrai );


%prob de cada clasificador
p = zeros(C,C,L);
for i = 1:L
p(:,:,i) = getConfucionMatrix( Ytrai, DP(:,i), C );
end


Yall = [Ytrai;Ycv];
N = length(Yall);

%prob a priori
prior = zeros(C,1);
for i=1:C
prior(i) = sum(Yall==i)/N; 
end


t = 1.0e-8;
p = (p < t).*t + (p >= t & p <= (1-t)).*p + (p > (1-t)).*(1-t);
prior = (prior < t).*t + (prior >= t & prior <= (1-t)).*prior + (prior > (1-t)).*(1-t);


end

