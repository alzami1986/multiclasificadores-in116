function CM = getConfucionMatrix( Y, Y_est, c  )
%getConfucionMatrix obtiene la matrix de conmfucion
%input
%Y clases esperadas
%Y_est clases estimadas 
%C No. de clases
%
%return
%CM matrix de confucion prob

CM = zeros(c);
clases = 1:c;

for i=1:c
    for j=1:c
    CM(i,j) = sum(Y == clases(i) & Y_est == clases(j));     
    end
end

%calculando la frecuencia de clada clase
frec_class = tabulate(Y);
frec_class = frec_class(:,2);

%probabilidad
CM = CM./repmat(frec_class,1,c);


end


