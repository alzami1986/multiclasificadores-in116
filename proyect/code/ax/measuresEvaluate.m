function [ AC, P, R, F1 ] = measuresEvaluate( Y, Yest, type )
%Calculo de las medidas de evaluacion
%Ref: http://www.cnts.ua.ac.be/~vincent/pdf/microaverage.pdf

% Microaveraged results are therefore
% really a measure of effectiveness on the large classes in a test
% collection. To get a sense of effectiveness on small classes, you
% should compute macroaveraged results (Manning et al., 2008).


cm = confusionmat(Y,Yest);
C = size(cm,1);
N = sum(cm(:));

%plotconfusion(OY,OYest)
% [c,cm,ind,per] = confusion(Y,Yest);
% 
% FN = per(:,1);
% FP = per(:,2);
% TP = per(:,3);
% TN = per(:,4);


[TP,TN,FP,FN] = deal(zeros(C,1));
for class = 1:C
   TP(class) = cm(class,class);
   tempMat = cm;
   tempMat(:,class) = []; % remove column
   tempMat(class,:) = []; % remove row
   TN(class) = sum(sum(tempMat));
   FP(class) = sum(cm(:,class))-TP(class);
   FN(class) = sum(cm(class,:))-TP(class);
end


AC = sum(TP)/N;
% AC = sum(diag(cm))/sum(cm(:));


if strcmp(type,'micro')

%Macro
%Bmacro = (1/C)sum_i B(tp_i,fp_i,fp_i,fn_i)
%B op binario

P = (1/C)*sum(TP./(TP+FP));
R = (1/C)*sum(TP./(TP+FN));
F1 = (1/C)*sum(2*TP./(2*TP + FP + FN + eps));

else

%Micro
%Bmicro = (1/C)B(sum_i tp_i,sum_i fp_i,sum_i fp_i,sum_i fn_i)
%B op binario

% AC = (sum(TP)+sum(TN))/sum(per(:));
P = sum(TP)/(sum(TP)+sum(FP));
R = sum(TP)/(sum(TP)+sum(FN));
F1 = 2*P*R/(R+P + eps);

end


% % P = sum(TP)/(sum(TP)+sum(FP));
% % R = sum(TP)/(sum(TP)+sum(FN));
% % F1 = 2*P*R/(R+P);



end

