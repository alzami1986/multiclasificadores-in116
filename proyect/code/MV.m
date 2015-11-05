function y = MV( DP )
%MV majority vote
%   Detailed explanation goes here

[M,L] = size(DP);
y = zeros(M,1);

%regla de votacion
for i=1:M
y(i) = mode(DP(i,:));
end

end

