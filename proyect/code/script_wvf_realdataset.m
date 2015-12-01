%% Multiclasificadores proyecto
% Paper: A weighted voting framework for classifiers ensembles
% Autor: Ludmila I. Kuncheva · Juan J. Rodríguez
% Springer-Verlag London 2012
% Objetivo:
% Experimento con bases de datos de la UCI Machine Learning
%

%% Initialization
clear ; close all; clc
addpath(genpath(pwd));

%% Create dateset

fprintf('Load dataset ...\n');

% create dataset
% % Function Fitting, Function approximation and Curve fitting.
% % simplefit_dataset     - Simple fitting dataset.
% % abalone_dataset       - Abalone shell rings dataset.
% % bodyfat_dataset       - Body fat percentage dataset.
% % building_dataset      - Building energy dataset.
% % chemical_dataset      - Chemical sensor dataset.
% % cho_dataset           - Cholesterol dataset.
% % engine_dataset        - Engine behavior dataset.
% % house_dataset         - House value dataset

% % Pattern Recognition and Classification
% % simpleclass_dataset   - Simple pattern recognition dataset.
% % cancer_dataset        - Breast cancer dataset.
% % crab_dataset          - Crab gender dataset.
% % glass_dataset         - Glass chemical dataset.
% % iris_dataset          - Iris flower dataset.
% % thyroid_dataset       - Thyroid function dataset.
% % wine_dataset          - Italian wines dataset.
%

% % % filename = 'abalone_dataset';
% % % [X,Y] = wine_dataset;
% % % [C,M] = size(Y);
% % % Y = sum(ones(M,C)*diag(1:C).*Y',2);
% % % X = X';


pathNameIn  = 'db/UCI/';
pathNameOut = 'out/xls/';

%filename = 'balance-scale'; %6
%filename = 'breast-cancer'; %8
%filename = 'zoo';
%filename = 'abalone';
filename = 'breast-w';


vars = {'target','input'};
db = load([pathNameIn filename '.mat'], vars{:});
X = db.input;
Y = db.target;
C = length( unique(Y) );
M = length(Y);

%Name of methods
methods = {'MV', 'WVM', 'RECALL', 'NB'};

fprintf('Dataset %s\n', filename)
fprintf('No. de objs: %d, No. clases: %d\n', M, C)


%% Inicializado methos

%Metodo de clasificacion 
fclassif = @fitctree;

%Experimento
K = 10;
% cv = cvpartition(Y,'k', K); 
cv = cvtpartition(Y,K); 
Ne = cv.NumTestSets;
L = 10; %100
R=10; %repite

acc_mv = zeros(R,K);
acc_wmv = zeros(R,K);
acc_rec = zeros(R,K);
acc_nb = zeros(R,K);


for r = 1:R 
for kf = 1:Ne
    
    %trIdx = cv.training(kf); 
    %teIdx = cv.test(kf);  
    trIdx = gettraining( cv, kf );
    cvIdx = getvalidation( cv, kf );
    teIdx = gettest( cv, kf );
    
    Xtra = X(trIdx,:); Ytra = Y(trIdx);
    Xcv = X(cvIdx,:); Ycv = Y(cvIdx);
    Xtes = X(teIdx,:); Ytes = Y(teIdx);
    
       
    
    %% Training 
    %Bagging
    models = bagging( fclassif, L, Xtra, Ytra, length(Ytra) );  
    
    %estimate param
    [prior, p] = estimateParam( models, Xcv, Ycv,Ytra, C, L );
    
  
        
    
    %% tEST
    %predict
    dp = predictAll( models, L, Xtes );
    
    
    %Aplicando relgas de fusion  
    
    %MV    
    y_mv = MV( dp );
    acc_mv(r,kf) = mean(double(y_mv == Ytes));   
    
    %WMV
    post = zeros(L,1);
    for i = 1:L
    post(i) = mean(diag(p(:,:,i)));   
    end       
    y_wmv = WMV( dp, C, post, prior );
    acc_wmv(r,kf) = mean(double(y_wmv == Ytes));
    
    %RECALL
    post = zeros(C,L);
    for i = 1:L
    post(:,i) = diag(p(:,:,i))';   
    end 
    y_rec = REC( dp, C, post, prior  );
    acc_rec(r,kf) = mean(double(y_rec == Ytes));
        
    %NB
    post = p;
    y_nb = NB( dp, C, post, prior );
    acc_nb(r,kf) = mean(double(y_nb == Ytes));
    
       
    
    fprintf('Iter %d -> %d ... \n', r, kf);
    
    
end



end

%% Save result

materr = [acc_mv(:), acc_wmv(:), acc_rec(:), acc_nb(:)];
tabela = [methods; num2cell(materr)];
xlswrite([pathNameOut 'wvfreal-' filename '.xlsx'], tabela);


%%  Result

fprintf('\nResult: \n');
fprintf('MV:        %.2d + %.2d \n', mean(acc_mv(:)), std(acc_mv(:)));
fprintf('WMV:       %.2d + %.2d \n', mean(acc_wmv(:)), std(acc_wmv(:)));
fprintf('RECALL:    %.2d + %.2d \n', mean(acc_rec(:)), std(acc_rec(:)));
fprintf('NB:        %.2d + %.2d \n', mean(acc_nb(:)), std(y_nb(:)));














