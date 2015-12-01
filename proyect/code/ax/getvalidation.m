function val = getvalidation( pvt, i )

k = pvt.NumTestSets;
iter = pvt.idx;

tes = (iter == i);
%val = (iter == (mod(i,k)+1));

val = ~(tes);
n = sum(val);
idx = find(val == 1);
val(idx(( (fix(n/2)+1):n ))) = 0;

val = pvt.mat_part(:,val);
val = sum(val,2)>=1;

%val = pvt.mat_part(:,val);

end

