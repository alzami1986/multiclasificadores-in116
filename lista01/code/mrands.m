function r = mrands( k, n )
%UNTITLED3 Summary of this function goes here


numrand = 1:n;
r = zeros(1,k);
for i=1:k
    pos = randi([1 n-i+1],1,1);
    r(i) = numrand(pos);
    numrand = [numrand(1:pos-1) numrand(pos+1:end)];
end 
r = sort(r);



% % % c = combnk(1:n,k);
% % % pos = randi([1 size(c,1)],1,1);
% % % r = c(pos,:);



end

