function ifile = searchRowCero( M, f, c )

m = size(M,1);
ifile = false(m,1);
for i=1:m
ifile(i) = (sum(M(i,:).*c)==0);
end


end

