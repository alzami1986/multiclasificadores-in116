function trai = gettraining( pvt, i)

k = pvt.NumTestSets;
iter = pvt.idx;

tes = (iter == i);
% val = (iter == (mod(i,k)+1));

trai = ~(tes);
n = sum(trai);
idx = find(trai == 1);
trai(idx(1:( fix(n/2) ))) = 0;

trai = pvt.mat_part(:,trai);
trai = sum(trai,2)>=1;

end

