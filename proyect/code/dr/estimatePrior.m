function p = estimatePrior( Y,C )



N = length(Y);
p = zeros(C,1);
for i=1:C
Nj = sum(Y==i); %numeros de elementos de la clase i    
p(i) = Nj/N;
end



end

