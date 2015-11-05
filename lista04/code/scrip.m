%% Multiclasificadores: lista 04 Seleccion dinamica 



%% Initialization
clear ; close all; clc
addpath(genpath(pwd));

%% Create dateset

fprintf('Cargar dataset ...\n')

% create dataset
% simpleclass_dataset   - Simple pattern recognition dataset.
% cancer_dataset        - Breast cancer dataset.
% crab_dataset          - Crab gender dataset.
% glass_dataset         - Glass chemical dataset.
% iris_dataset          - Iris flower dataset.
% thyroid_dataset       - Thyroid function dataset.
% wine_dataset          - Italian wines dataset.
%

filename = 'wine_dataset';
[objs,class] = wine_dataset;
[mc,nc] = size(class);
class = sum(ones(nc,mc)*diag(1:mc).*class',2);
objs = objs';

% % % filename = 'arrhythmia.mat';
% % % vars = {'X','Y'};
% % % db = load(filename,vars{:});
% % % objs = db.X; 
% % % class = db.Y;
% % % nc = length(class); mc = length(unique(class));

fprintf('Dataset %s\n', filename)
fprintf('No. de objs: %d, No. clases: %d\n', nc, mc)



%% Inicializado experimentos
% Metodo de clasificacion 
funcC = @fitctree;

k = 10;
pt = cvtpartition(class,k); 
num_exp = pt.NumTestSets;
L = 10;

fprintf('Metodo de clasificacion: DTree \n');
fprintf('K-fold: k = %d \n', k);
fprintf('Size of pool: L = %d \n', L);


%err = zeros(num_exp,1);
nK = 15;
iK = 3;
lK = nK-iK+1; 

err_ola = zeros(num_exp,lK);
err_lca = zeros(num_exp,lK);
err_dsknn = zeros(num_exp,lK);
err_dsc = zeros(num_exp,lK);
err_dsbo = zeros(num_exp,lK);
err_dsknnd = zeros(num_exp,lK);


for kf=1:num_exp
    
    gtra = gettraining( pt, kf );
    gcv = getvalidation( pt, kf );
    gtes = gettest( pt, kf );
    
    %% Bagging
    pool = createPoolBagging( funcC, L, objs(gtra,:), class(gtra), sum(gtra) ); 
    
    
    %% Estimando las clases para cada clasificador
    Ycv_est = evaluatePool( pool, L, objs(gcv,:) );
    Ytes_est = evaluatePool( pool, L, objs(gtes,:) );
    
    
    %% Seleccion dinamica 
    
    Xcv = objs(gcv,:);
    Ycv = class(gcv);    
    Xtes = objs(gtes,:);
        
    
    for K=iK:nK
        
        rng(1); % For reproducibility
        [Gi,Gc] = kmeans(Xcv,K);
        
        Bo = K/10000; %0.0002;
        [BGi,BGn] = boconexo(Xcv,Bo,'euc');        
        BR = [];
        for r=1:BGn
        idx = (BGi == r);
        Ra = getrepresentantes(Xcv(idx,:), Bo, 0.1);
        Ra = [Ra r.*ones(size(Ra,1),1)];
        BR = [BR;Ra];
        end
               
        
        %Para todos los objetos de test
        Ytf_ola = zeros(sum(gtes),1);
        Ytf_lca = zeros(sum(gtes),1);
        Ytf_dsknn = zeros(sum(gtes),1);
        Ytf_dsc = zeros(sum(gtes),1);
        Ytf_dsbo = zeros(sum(gtes),1);
        Ytf_dsknnd = zeros(sum(gtes),1);
        
        for i=1:sum(gtes)
            
            S = OLA( Xcv, Ycv, Ycv_est, Xtes(i,:), Ytes_est(i,:), K );
            Ytf_ola(i) = mode(Ytes_est(i,S));
            
            S = LCA( Xcv, Ycv, Ycv_est, Xtes(i,:), Ytes_est(i,:), K );
            Ytf_lca(i) = mode(Ytes_est(i,S));
            
            S = DS_KNN( Xcv, Ycv, Ycv_est, Xtes(i,:), Ytes_est(i,:), K, 5,3 );
            Ytf_dsknn(i) = mode(Ytes_est(i,S));
                 
            S = DSC( Xcv, Ycv, Ycv_est, Gi, Gc, Xtes(i,:), Ytes_est(i,:), 5, 3);
            Ytf_dsc(i) = mode(Ytes_est(i,S));
                        
            S = DSBo( Xcv, Ycv, Ycv_est, BGi, BR, Xtes(i,:), Ytes_est(i,:), 5, 3);
            Ytf_dsbo(i) = mode(Ytes_est(i,S));
                       
            S = DS_KNND( Xcv, Ycv, Ycv_est, Xtes(i,:), Ytes_est(i,:), K, 5,3 );
            Ytf_dsknnd(i) = mode(Ytes_est(i,S));
            
                        
        end
        
        err_ola(kf,K-iK+1) = calcError(class(gtes),Ytf_ola);
        err_lca(kf,K-iK+1) = calcError(class(gtes),Ytf_lca);
        err_dsknn(kf,K-iK+1) = calcError(class(gtes),Ytf_dsknn);
        err_dsc(kf,K-iK+1) = calcError(class(gtes),Ytf_dsc);
        err_dsbo(kf,K-iK+1) = calcError(class(gtes),Ytf_dsbo);
        err_dsknnd(kf,K-iK+1) = calcError(class(gtes),Ytf_dsknnd);
    
    end
    
    fprintf('Iter: %d ...\n',kf);
 
    
    
    
end

err_ola_m = sum(err_ola)./num_exp;
err_lca_m = sum(err_lca)./num_exp;
err_dsknn_m = sum(err_dsknn)./num_exp;
err_dsc_m = sum(err_dsc)./num_exp;
err_dsbo_m = sum(err_dsbo)./num_exp;
err_dsknnd_m = sum(err_dsknnd)./num_exp;

err_general = [err_ola_m; err_lca_m; err_dsknn_m; err_dsc_m; ...
    err_dsbo_m; err_dsknnd_m];


%% Resultados

%save('DS_WINE_KNND');


%% Plot

namemt = {'OLA','LCA','DSKNN','DSC','DSB0','DSKNND'};

figure1 = figure;
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on');
box(axes1,'on');
hold(axes1,'all');

hold on
plot(err_ola_m, 'DisplayName',namemt{1});
plot(err_lca_m, 'DisplayName',namemt{2});
plot(err_dsknn_m, 'DisplayName',namemt{3});
plot(err_dsc_m, 'DisplayName',namemt{4});
plot(err_dsbo_m, 'DisplayName',namemt{5});
plot(err_dsknnd_m, 'DisplayName',namemt{6});
hold off


% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Interpreter','latex');
%legend('boxoff')

% axis([0 1 0 1]);

% Create xlabel
xlabel('Parameters');

% Create ylabel
ylabel('Error');

