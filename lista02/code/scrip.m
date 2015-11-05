


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

[objs,class] = wine_dataset;
for i=1:size(class,1)
class(i,:) = class(i,:).*i;
end
class = sum(class,1);
class = class(:); objs = objs';

% % load ionosphere;
% % yuniq = unique(Y);
% % class = zeros(length(Y),1);
% % for i=1:length(yuniq)
% % ind = strcmp(Y,yuniq(i));
% % class(ind) = i;
% % end
% % objs = X;

% method
%@fitcknn;
%@fitctree
%@fitcnb
%@fitcsvm
%@fitcecoc
func = {@fitctree,@fitcknn,@fitcnb};
N = 1;

%experimento
k = 10;
CVO = cvpartition(class,'k', k); 
L = 10;
dimsub = 5;

Rbag = cell(N,1);
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

stats = cell(CVO.NumTestSets,ii);
for kf = 1:CVO.NumTestSets
    
    trIdx = CVO.training(kf); %trai
    teIdx = CVO.test(kf);  %test
    
    %RandomSubspace
    pool = createPoolBagging( func{ii}, L, objs(trIdx,:), class(trIdx), sum(trIdx) );
    
    %% Calculando ensamble
    y = classBaggingSerie( pool, L, objs(teIdx,:));
   
    
    %calcular medidas
    mat = createConfusionMat(y(L,:)',class(teIdx)); 
    st = confusionmatStats(mat);
    
        
    %% Calculando las medidas de diversidad 
    
    %empleando medidas pareadas
    funcdiv = @Qst;
    st.divQst = DiversidadeMedia(y,class(teIdx),funcdiv);    
    funcdiv = @CoefRo;
    st.divCRo = DiversidadeMedia(y,class(teIdx),funcdiv);  
    funcdiv = @Dis;
    st.divDis = DiversidadeMedia(y,class(teIdx),funcdiv);  
    funcdiv = @DouF;
    st.divDF = DiversidadeMedia(y,class(teIdx),funcdiv);  
        
    %no pareadas
    st.divE = EntropyMeasure(y,class(teIdx));
    st.divKW = KohaviWolpertVariance(y,class(teIdx));
    st.divIA = MeasureInterraterAgreement(y,class(teIdx));
    
    %medidas difficulty
    st.divHist = histclass(y,class(teIdx));
    st.divWW = myDiversidadFunc(y,class(teIdx));
    st.divDiff = Difficulty( y, class(teIdx) );
    st.divGD = GeneralizedDiversity(y,class(teIdx));
    st.divCFD = CoincidentFailureDiversity(y,class(teIdx));
   
    
    stats{kf,ii} = st;    
    disp(kf)
    
end

   
end

save('Rdiv2');

%% ploting
%divQst,divCro,divDis,divDF, divE, divKw, divIA, divGD, divCFD

matResult = zeros(CVO.NumTestSets,11);
for i=1:CVO.NumTestSets
matResult(i,1)=i;
matResult(i,2)=stats{i,1}.divQst;
matResult(i,3)=stats{i,1}.divCRo;
matResult(i,4)=stats{i,1}.divDis;
matResult(i,5)=stats{i,1}.divDF;
matResult(i,6)=stats{i,1}.divE; 
matResult(i,7)= stats{i,1}.divKW;
matResult(i,8)=stats{i,1}.divIA;
matResult(i,9)= stats{i,1}.divDiff;
matResult(i,10)= stats{i,1}.divGD; 
matResult(i,11)= stats{i,1}.divCFD;
matResult(i,12)= stats{i,1}.divWW;
matResult(i,13)= stats{i,1}.accuracy;
end

plot(matResult(:,2:13));
legend({'Qst','p','Dis','DF', 'E', 'Kw', 'k', 'Diff', 'GD', 'CFD','Dp','Acc'});
xlabel('Numero de pool');
ylabel('Valor de diversidade');
title('Analisis de Diversidade');


%%
nameMedidas = {'Qst','p','Dis','DF', 'E', 'Kw', 'k', 'Diff', 'GD', 'CFD','Dp','Acc'};
for i=2:12
%subplot(1,11,i-1);
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on');
box(axes1,'on');
hold(axes1,'on');

plot(matResult(:,i),matResult(:,13),'MarkerFaceColor',[0 0 0],'Marker','o','LineStyle','none',...
    'Color',[0 0 0])


xlabel(nameMedidas{i-1});
ylabel('Accuracy');

end

%%
Cor = corr(matResult(:,2:12));



