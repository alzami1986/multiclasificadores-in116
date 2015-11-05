function icol = searchColumnSumN( M,f,c, s)

n = size(M,2);
icol = false(n,1);
for i=1:n
icol(i) = (sum(M(:,i).*f(:))==s);
end


end
