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

filename = 'cancer_dataset';
[objs,class] = cancer_dataset;
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
L = 100;
I = 10;

p = 100; %\%
K = 5;

fprintf('Metodo de clasificacion: DTree \n');
fprintf('K-fold: k = %d \n', k);
fprintf('Size of pool: L = %d \n', L);


%err = zeros(num_exp,1);
err_sel_lca = zeros(num_exp,1);
err_sel_ola = zeros(num_exp,1);
err_sel_dsknn = zeros(num_exp,1);
err_sel_kne = zeros(num_exp,1);
err_sel_dsc = zeros(num_exp,1);

err_sel_poda_lca = zeros(num_exp, L - I + 1);
err_sel_poda_ola = zeros(num_exp, L - I + 1);
err_sel_poda_dsknn = zeros(num_exp, L - I + 1);
err_sel_poda_kne = zeros(num_exp, L - I + 1);
err_sel_poda_dsc = zeros(num_exp, L - I + 1);



err_poda = zeros(num_exp,L);

for kf=1:num_exp
    
    gtra = gettraining( pt, kf );
    gcv = getvalidation( pt, kf );
    gtes = gettest( pt, kf );
    
    %% Bagging
    pool = createPoolBagging( funcC, L, objs(gtra,:), class(gtra), sum(gtra) ); 
      
    
    %% Estimando las clases para cada clasificador
    Ycv_est = evaluatePool( pool, L, objs(gcv,:) );        
    Ytes_est = evaluatePool( pool, L, objs(gtes,:) );    
    
    
    %Poda
    ens = EPIC( Ycv_est', class(gcv),p);
        
    
    
    %% Seleccion dinamica 
    Xcv = objs(gcv,:);
    Ycv = class(gcv);    
    Xtes = objs(gtes,:);
          
    
     rng(1); % For reproducibility
    [Gi,Gc] = kmeans(Xcv,5);
    
    Ytf_sel_lca = zeros(sum(gtes),1);  
    Ytf_sel_ola = zeros(sum(gtes),1);
    Ytf_sel_dsknn = zeros(sum(gtes),1);
    Ytf_sel_kne = zeros(sum(gtes),1);
    Ytf_sel_dsc = zeros(sum(gtes),1);
    
    
    
    for i=1:sum(gtes)
          
        
        %selec
        S = LCA( Xcv, Ycv, Ycv_est, Xtes(i,:), Ytes_est(i,:), K );
        Ytf_sel_lca(i) = mode(Ytes_est(i,S));
        S = OLA( Xcv, Ycv, Ycv_est, Xtes(i,:), Ytes_est(i,:), K );    
        Ytf_sel_ola(i) = mode(Ytes_est(i,S));
        S = DS_KNN( Xcv, Ycv, Ycv_est, Xtes(i,:), Ytes_est(i,:), K, 5,3 );
        Ytf_sel_dsknn(i) = mode(Ytes_est(i,S));
        S = KNE( Xcv, Ycv, Ycv_est, Xtes(i,:), K );       
        Ytf_sel_kne(i) = mode(Ytes_est(i,S));
        S = DSC( Xcv, Ycv, Ycv_est, Gi, Gc, Xtes(i,:), Ytes_est(i,:), 5, 3);
        Ytf_sel_dsc(i) = mode(Ytes_est(i,S));
        
        
    end
    
    err_sel_lca(kf) = calcError(class(gtes),Ytf_sel_lca);
    err_sel_ola(kf) = calcError(class(gtes),Ytf_sel_ola);
    err_sel_dsknn(kf) = calcError(class(gtes),Ytf_sel_dsknn);
    err_sel_kne(kf) = calcError(class(gtes),Ytf_sel_kne);
    err_sel_dsc(kf) = calcError(class(gtes),Ytf_sel_dsc);
     
     
    
    for d=I:L    
    %Para todos los objetos de test
    Ytf_sel_poda_lca = zeros(sum(gtes),1);  
    Ytf_sel_poda_ola = zeros(sum(gtes),1);
    Ytf_sel_poda_dsknn = zeros(sum(gtes),1);
    Ytf_sel_poda_kne = zeros(sum(gtes),1);
    Ytf_sel_poda_dsc = zeros(sum(gtes),1);
    
    
    for i=1:sum(gtes)        
        %poda
        S = LCA( Xcv, Ycv, Ycv_est(:,ens(1:d)), Xtes(i,:), Ytes_est(i,ens(1:d)), K );
        Ytf_sel_poda_lca(i) = mode(Ytes_est(i,ens(S)));
        S = OLA( Xcv, Ycv, Ycv_est(:,ens(1:d)), Xtes(i,:), Ytes_est(i,ens(1:d)), K );
        Ytf_sel_poda_ola(i) = mode(Ytes_est(i,ens(S)));
        S = DS_KNN( Xcv, Ycv, Ycv_est(:,ens(1:d)), Xtes(i,:), Ytes_est(i,ens(1:d)), K, 5,3 );
        Ytf_sel_poda_dsknn(i) = mode(Ytes_est(i,ens(S)));
        S = KNE( Xcv, Ycv, Ycv_est(:,ens(1:d)), Xtes(i,:), K );   
        Ytf_sel_poda_kne(i) = mode(Ytes_est(i,ens(S)));
        S = DSC( Xcv, Ycv, Ycv_est(:,ens(1:d)), Gi, Gc, Xtes(i,:), Ytes_est(i,ens(1:d)), 5, 3);
        Ytf_sel_poda_dsc(i) = mode(Ytes_est(i,ens(S)));
        
    end      
    err_sel_poda_lca(kf,d-I+1) = calcError(class(gtes),Ytf_sel_poda_lca);   
    err_sel_poda_ola(kf,d-I+1) = calcError(class(gtes),Ytf_sel_poda_ola); 
    err_sel_poda_dsknn(kf,d-I+1) = calcError(class(gtes),Ytf_sel_poda_dsknn); 
    err_sel_poda_kne(kf,d-I+1) = calcError(class(gtes),Ytf_sel_poda_kne); 
    err_sel_poda_dsc(kf,d-I+1) = calcError(class(gtes),Ytf_sel_poda_dsc); 
      
    
    
    end
        
%     fprintf('Iter: %d, e_sel %.2f, e_poda %.2f \n', ...
%         kf, err_sel(kf), mean(err_sel_poda(kf,:)));
    
     fprintf('Iter: %d \n',kf);
    
    
end

%%

% err_sel_m = sum(err_sel)./num_exp;
% err_sel_poda_m = sum(err_sel_poda)./num_exp;


    
err_sel_lca_m = sum(err_sel_lca)./num_exp;
err_sel_ola_m = sum(err_sel_ola)./num_exp;
err_sel_dsknn_m = sum(err_sel_dsknn)./num_exp;
err_sel_kne_m = sum(err_sel_kne)./num_exp;
err_sel_dsc_m = sum(err_sel_dsc)./num_exp;

err_general_sel = [err_sel_lca_m; err_sel_ola_m; err_sel_dsknn_m; err_sel_kne_m; ...
    err_sel_dsc_m];


err_sel_poda_lca_m = sum(err_sel_poda_lca)./num_exp;
err_sel_poda_ola_m = sum(err_sel_poda_ola)./num_exp;
err_sel_poda_dsknn_m = sum(err_sel_poda_dsknn)./num_exp;
err_sel_poda_kne_m = sum(err_sel_poda_kne)./num_exp;
err_sel_poda_dsc_m = sum(err_sel_poda_dsc)./num_exp;

err_general_sel_poda = [err_sel_poda_lca_m; err_sel_poda_ola_m; err_sel_poda_dsknn_m; err_sel_poda_kne_m; ...
    err_sel_poda_dsc_m];



%% Resultados

save('RpodaSelect04');


%% Plot

namemt = {'LCA','OLA','DS-KNN','KINORA-E','DS-CLUSTERS'};
namemtp = {'PODA/LCA','PODA/OLA','PODA/DS-KNN','PODA/KINORA-E','PODA/DS-CLUSTERS'};


for ex = 1:5
figure1 = figure;
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on');
box(axes1,'on');
hold(axes1,'all');


%ex = 2;
plot(repmat(err_general_sel(ex),1,length(err_general_sel_poda)), 'DisplayName',namemt{ex});
hold on
plot(err_general_sel_poda(ex,:), 'DisplayName',namemtp{ex});
hold off


% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Interpreter','latex');
%legend('boxoff')


% Create xlabel
xlabel('Number of classifiers');

% Create ylabel
ylabel('Error');

end