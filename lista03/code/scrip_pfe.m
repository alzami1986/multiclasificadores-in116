
%% Multiclasificadores: lista 03 poda


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
% % [objs,class] = glass_dataset;
% % [mc,nc] = size(class);
% % class = sum(ones(nc,mc)*diag(1:mc).*class',2);
% % objs = objs';

filename = 'arrhythmia.mat';
vars = {'X','Y'};
db = load(filename,vars{:});
objs = db.X; 
class = db.Y;
nc = length(class); mc = length(unique(class));

fprintf('Dataset %s\n', filename)
fprintf('No. de objs: %d, No. clases: %d\n', nc, mc)



%% Inicializando exp
% Metodo de clasificacion
funcC = @fitctree;

% Grupos trai, val, tes
trainRatio = 0.33;
valRatio = 0.33;
testRatio = 0.33;
[gtra, gval, gtes] = dividerand(nc,trainRatio,valRatio,testRatio);
group = {gtra, gval, gtes};
indxgrup = perms([1 2 3]);
%indxgrup = [1 2 3];

% Size maximo del pool
L = 10;
p = 100;

fprintf('EPS\n');
fprintf('Tamaño del pool L = %d\n',L);


%% Calculando error
num_exp = size(indxgrup,1);
err_pool = zeros(num_exp,L);
err_ens = zeros(num_exp,L);
err_ens2 = zeros(num_exp,L);

ens_red = zeros(num_exp,L);

for k = 1:num_exp
    
    
    fprintf('Iter: %d ...\n',k);
    
    
    indx = indxgrup(k,:);
    gtra = group{indx(1)};
    gval = group{indx(2)};
    gtes = group{indx(3)};

    
    %Bagging
    pool = createPoolBagging( funcC, L, objs(gtra,:), class(gtra), length(gtra) );    
    ens2 = EPIC( pool, L, objs(gtes,:), class(gtes),p);   
    ens = EPS( pool, L, objs(gtes,:), class(gtes),p);
    
    
    %% Calculando ensambles
    ypool = evaluatePool( pool, L, objs(gval,:) );
        
    
    %regla de votacion
    yp = zeros(L,length(gval));
    ye = zeros(L,length(gval));
    ye2 = zeros(L,length(gval));
    for i=1:L
    yp(i,:) = mode(ypool(:,1:i),2);
    ye(i,:) = mode(ypool(:,ens(1:i)),2);
    ye2(i,:) = mode(ypool(:,ens2(1:i)),2);
    end
        
    %calcError
    for m=1:L        
    err_pool(k,m) = calcError(yp(m,:)',class(gval));    
    err_ens(k,m) = calcError(ye(m,:)',class(gval)); 
    err_ens2(k,m) = calcError(ye2(m,:)',class(gval)); 
    end
    
    
    
    
end

err_pool_m = sum(err_pool,1)./size(err_pool,1);
err_ens_m = sum(err_ens,1)./size(err_ens,1);
err_ens_m2 = sum(err_ens2,1)./size(err_ens2,1);
%ens_red_m = sum(ens_red,1)./size(ens_red,1);

%save('RpodaEPS2_GDL100');


%% ploting

figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on');
box(axes1,'on');
hold(axes1,'on');

plot(err_pool_m,'g-');
hold on;
plot(err_ens_m,'r-')
plot(err_ens_m2,'b-')
hold off;

legend({'bagging','EPS','EPIC'});
xlabel('Number of classifiers');
ylabel('Error');
title('Analysis for L = 100');

% % figure2 = figure;
% % plot(ens_red_m,'b-')



