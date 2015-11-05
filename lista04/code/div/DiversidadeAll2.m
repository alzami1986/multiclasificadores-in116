function Div = DiversidadeAll2(y, class, func )


[L,~] = size(y);
R = abs(y'-repmat(class,1,L)) == 0;
Div = zeros(L,L);

for i=1:L-1
    for j=(i+1):L

    r1 = R(:,i); r2 = R(:,j);
    a = sum(r1.*r2);
    b = sum(r1.*~r2);
    c = sum(~r1.*r2);
    d = sum(~r1.*~r2);    
      
    Div(i,j) = feval(func,a,b,c,d);
    
    end
end







end

