function icol = searchColumnCero( M )

n = size(M,2);
icol = false(n,1);
for i=1:n
icol(i) = (sum(M(:,i))==0);
end


end

