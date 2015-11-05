function Medida = DiversidadeMedia(y, class, func )


[L,N] = size(y);
R = abs(y'-repmat(class,1,L)) == 0;
Medida = 0;

for i=1:L-1
    for j=(i+1):L

    r1 = R(:,i); r2 = R(:,j);
    a = sum(r1.*r2);
    b = sum(r1.*~r2);
    c = sum(~r1.*r2);
    d = sum(~r1.*~r2);    
            
%     %Q Statistics 
%     M = Qst(a,b,c,d);
%     %Correlation Coefficient 
%     M = CoefRo(a,b,c,d);
%     %Disagreement Measure
%     M = Disagreement(a,b,c,d);
%     %Double-Fault Measure
%     M = DoubleFaultMeasure(a,b,c,d);    
    
    M = feval(func,a,b,c,d);
    Medida = Medida + M;  
    
    
    end
end

Medida = (2/(L*(L-1)))*Medida;


end

