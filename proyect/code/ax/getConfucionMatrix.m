function cm = getConfucionMatrix( Y, Y_est, c, varargin  )
%getConfucionMatrix obtiene la matrix de conmfucion
%input
%Y clases esperadas
%Y_est clases estimadas 
%C No. de clases
%
%return
%CM matrix de confucion prob

bprob = 1;
if nargin == 4
bprob = varargin{1};
end

cm = confusionmat(Y,Y_est);

%Calculando la frecuencia de cada clase
if bprob
cm = cm./(repmat(sum(cm,2),1,c)); %P(s_i = w_k|w_k)
end



end


