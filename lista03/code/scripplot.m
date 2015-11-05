

figure;
lines = {'-.k', '--k', 'k'};

for ii=1:N
    
ETST = Rbag{ii}.ETST;
EORG = Rbag{ii}.EORG;
hold on 
plot(ETST);
x = 1:length(ETST); y = ones(length(ETST),1).*EORG;
plot(x,y,lines{ii});
hold off

end

legend({'Bayes','BayesTest','KNN','KNNTest','DT','DTTest'});
xlabel('Numero de classificadores');
ylabel('Erro de classificação (10 fold)');
title('Bagging');
