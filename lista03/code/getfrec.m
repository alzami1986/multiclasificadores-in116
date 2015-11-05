function frec = getfrec( x,n )

frec = zeros(n,1);
for k=1:length(x)
frec(x(k)) = frec(x(k)) + 1;
end

end

