function Yexp = expandcol( Y, m )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

n = length(Y);
Yexp = zeros(n,m);
for i=1:n
Yexp(i,Y(i)) = 1;
end

end

