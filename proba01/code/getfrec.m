function frec = getfrec( x,n )

frec = zeros(n+1,1);
for k=1:length(x)
frec(x(k)+1) = frec(x(k)+1) + 1;
end
frec = frec(2:end);


end

