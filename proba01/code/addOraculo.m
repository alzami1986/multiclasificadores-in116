function [ h, orc, c ] = addOraculo( h, class )

%%%
%Add oraculo

[M,L] = size(h);
orc = randi([1 L],1,1);
c = unique(class);
i = randi([1 length(c)],1,1);
c = c(i);
H = abs(h-repmat(class,1,L)) == 0;
H = sum(H);
iorcs = (H == M);

if sum(iorcs) == 0
h(:,orc) = double((class == c).*c);  
else
iorcs = find(iorcs);
orc = iorcs(1);
end




%%%



end

