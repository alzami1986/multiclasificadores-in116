function y = MV( dp )
%MV majority vote
%   Detailed explanation goes here

[M,~] = size(dp);
y = zeros(M,1);

%regla de votacion
for i=1:M
y(i) = mode(dp(i,:));
end

end

