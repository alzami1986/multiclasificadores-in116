function ens = EPIC( h, class, p  )

[L,M] = size(h);


%calcular grupos mayoritario
gm = mode(h);
nC = max(class);
IC = zeros(L,M);
for i=1:L
    for j=1:M
    
       alpha = (h(i,j)== class(j))&(h(i,j)~=gm(j));
       beta =  (h(i,j)== class(j))&(h(i,j)==gm(j));
       theta =  (h(i,j)~= class(j));
        
       v_h = sum(h(:,j)==h(i,j));
       v_corr = sum(h(:,j)==class(j));
       v_max = sum(h(:,j)==gm(j));       
       
       fsecc = getfrec(h(:,j),nC);       
       [~,I] = sort(fsecc,'descend');
       v_sec = sum(h(:,j)==I(2)); 
              
       IC(i,j) = (2*v_max - v_h)*alpha;
       IC(i,j) = IC(i,j) + v_sec*beta;
       IC(i,j) = IC(i,j) + (v_corr - v_h - v_max)*theta;
        
    end
end

IC = sum(IC,2);
T = fix((p*L)/100);
[~,I] = sort(IC,'descend');
ens = I(1:T);


end

