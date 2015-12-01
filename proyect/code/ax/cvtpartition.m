function pvt = cvtpartition( class, k )


pt = cvpartition(class,'k', k); 
N = pt.NumTestSets;

pvt.NumObservations = pt.NumObservations;
pvt.NumTestSets = pt.NumTestSets;
mat_part = false(pt.NumObservations,k);
for i=1:N
mat_part(:,i) = pt.test(i);
end

pvt.mat_part = mat_part;
pvt.idx = 1:N;


end

