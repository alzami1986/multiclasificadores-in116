%%Experimentos con metodo Randomsubspace

clc;
clear;

% dataset
% simpleclass_dataset   - Simple pattern recognition dataset.
% cancer_dataset        - Breast cancer dataset.
% crab_dataset          - Crab gender dataset.
% glass_dataset         - Glass chemical dataset.
% iris_dataset          - Iris flower dataset.
% thyroid_dataset       - Thyroid function dataset.
% wine_dataset          - Italian wines dataset.

[objs,class] = cancer_dataset;
for i=1:size(class,1)
class(i,:) = class(i,:).*i;
end
class = sum(class,1);
class = class(:); objs = objs';

% load ionosphere;
% %load fisheriris;
% yuniq = unique(Y);
% class = zeros(length(Y),1);
% for i=1:length(yuniq)
% ind = strcmp(Y,yuniq(i));
% class(ind) = i;
% end
% objs = X;

% method
%@fitcknn;
%@fitctree
%@fitcnb
%@fitcsvm
%@fitcecoc
func = {@fitcnb,@fitcknn, @fitctree};
N = 3;

%experimento
k = 10;
CVO = cvpartition(class,'k', k); 
MaxC = 100;
%ETRA = zeros(MaxC,1);
ETST = zeros(MaxC,1);
dimsub = 5;

Rrsp = cell(N,1);
for ii = 1:N

%% Calculando error del metodo
EORG = zeros(CVO.NumTestSets,1);
for kf = 1:CVO.NumTestSets        
    trIdx = CVO.training(kf); %trai
    teIdx = CVO.test(kf);  %test
    model = feval(func{ii},objs(trIdx,:), class(trIdx));
    y = predict(model,objs(teIdx,:));
    EORG(kf) = calcError(y,class(teIdx));
end
EORG = mean(EORG);


err_tst = zeros(CVO.NumTestSets,MaxC);
for kf = 1:CVO.NumTestSets
    
    trIdx = CVO.training(kf); %trai
    teIdx = CVO.test(kf);  %test
    
    %RandomSubspace
    pool = createPoolRandomSubspace( func{ii}, MaxC, objs(trIdx,:), class(trIdx), dimsub );
    
    %% Calculando ensamble
    y_tst = classRandomSubspaceSerie( pool, MaxC, objs(teIdx,:));
       
    for m=1:MaxC
    err_tst(kf,m) = calcError(y_tst(m,:)',class(teIdx)); 
    end    
    
%     for m=1:MaxC
%     y_tst = classRandomSubspace( pool, m, objs(teIdx,:));
%     err_tst(kf,m) = calcError(y_tst,class(teIdx));        
%     end
    
    disp(kf)
    
end

ETST = mean(err_tst);

%save
Rrsp{ii}.ETST = ETST;
Rrsp{ii}.EORG = EORG;

    
end



%save('Rrsp');

%% Ploting result


figure;
lines = {'-.k', '--k', 'k'};

for ii=1:N
    
ETST = Rrsp{ii}.ETST;
EORG = Rrsp{ii}.EORG;
hold on 
plot(ETST);
x = 1:length(ETST); y = ones(length(ETST),1).*EORG;
plot(x,y,lines{ii});
hold off

end

legend({'Bayes','BayesTest','KNN','KNNTest','DT','DTTest'});
xlabel('Numero de classificadores');
ylabel('Erro de classificação (10 fold)');
title('Random Subspace');





