
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
[objs,class] = cancer_dataset;
[mc,nc] = size(class);
class = sum(ones(nc,mc)*diag(1:mc).*class',2);
objs = objs';

% % filename = 'arrhythmia.mat';
% % vars = {'X','Y'};
% % db = load(filename,vars{:});
% % objs = db.X; 
% % class = db.Y;
% % nc = length(class); mc = length(unique(class));
% % 
% % fprintf('Dataset %s\n', filename)
% % fprintf('No. de objs: %d, No. clases: %d\n', nc, mc)



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

fprintf('EPIC\n');
fprintf('Tamaño del pool L= %d\n',L);


%% Calculando error
num_exp = size(indxgrup,1);
err_pool = zeros(num_exp,L);
err_ens = zeros(num_exp,L);


Ne = 10;
err = zeros(num_exp,Ne);
div = zeros(num_exp,Ne);


for L = 10:10:Ne*10
for k = 1:num_exp
    
    indx = indxgrup(k,:);
    gtra = group{indx(1)};
    gval = group{indx(2)};
    gtes = group{indx(3)};

    
    %Bagging
    pool = createPoolBagging( funcC, L, objs(gtra,:), class(gtra), length(gtra) );    
    h = evaluatePool( pool, L, objs(gval,:) );  
       

    %[ h, orc, c ] = addOraculo( h, class(gval) );  
    [ h, orc ] = addOraculoR( h,objs(gval,:) ,class(gval) );
    div(k,L/10) = CoincidentFailureDiversity(h',class(gval));
        
        
    ens = EPIC( h', class(gval),p);   
    pos = find(ens==orc);
    err(k,L/10) = pos/L;
    
    fprintf('Orc: %d, Err %.3f, Div %.2f \n',orc, err(k,L/10), div(k,L/10) );
       
    
    
end

fprintf('-----------------------------\n' );

end

%%

err_m = mean(err);
div_m = mean(div,1);

save('RpodaAp01');


%% ploting

figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on');
box(axes1,'on');
hold(axes1,'on');

plot(err_m, 'DisplayName','Error');
hold on 
plot(div_m, 'DisplayName', 'CFD');
hold off


% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Interpreter','latex');
%legend('boxoff')

xlabel('Number of classifiers');
ylabel('Error');
% title('Analysis for L = 10');






