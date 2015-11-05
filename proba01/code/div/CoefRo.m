function M = CoefRo( a,b,c,d )

%Correlation Coefficient 
P = (a*d - b*c)/(sqrt((a+b)*(c+d)*(a+c)*(b+d)) + eps);
M = P;

end


