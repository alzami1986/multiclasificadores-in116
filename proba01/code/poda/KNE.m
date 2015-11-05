function EoC = KNE( Xcv, Ycv, Ycv_est, Xtes, K )


k = K;
L = size(Ycv_est,2);
U = knnsearch(Xcv,Xtes,'K',K);

while k>0
    
Ui = U(1:k); 
n = length(Ui);
hij = abs(repmat(Ycv(Ui,:),1,L) - Ycv_est(Ui,:)) == 0;
H = sum(hij);
orcs = (sum(H) == n);

if sum(orcs) ~= 0
break;
end

k = k - 1;

end


if k == 0
hij =  abs(repmat(Ycv(U,:),1,L) - Ycv_est(U,:)) == 0;
H = sum(hij);
[mx , ~] = max(H);
orcs = (H == mx);
end

EoC = find(orcs);

end

