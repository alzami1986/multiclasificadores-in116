function M = Qst( a,b,c,d )

%Q Statistics
Qst = (a*d - b*c)/(a*d + b*c + eps);
M = Qst;

end

