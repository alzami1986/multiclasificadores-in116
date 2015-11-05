function Div = DiversidadeAll(y, class, func )


[L,~] = size(y);
R = abs(y'-repmat(class,1,L)) == 0;
Div = zeros(L*(L-1)/2,3);
%Div = zeros(L,L);


k = 1;
for i=1:L-1
    for j=(i+1):L

    r1 = R(:,i); r2 = R(:,j);
    a = sum(r1.*r2);
    b = sum(r1.*~r2);
    c = sum(~r1.*r2);
    d = sum(~r1.*~r2);    
    
    Div(k,1) = feval(func,a,b,c,d);    
    Div(k,2) = i; 
    Div(k,3) = j;        
    k = k+1;   
    
%     Div(i,j) = feval(func,a,b,c,d);
    
    end
end







end

