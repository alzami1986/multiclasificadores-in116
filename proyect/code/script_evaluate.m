%% Multiclasificadores proyecto
% Objetivo: Obtener medidas estadisticas 
% Observaciones: Actores 

%% Initialization
clear ; close all; clc
addpath(genpath(pwd));


%% Load data

pathNameIn = 'out/tablas/';
pathNameOut = 'out/xls/';

methFusion = {'Yrp','Yrs','Yrmax','Yrmin','Yrmed','Yrmj','Ymv','Ywmv','Yrec','Ynb','Ylop'};
listDbs = {'rowdb', 'wgdb', 'lbpdb', 'hogdb'};
listcomb = geticombine();

%Todas las combinaciones 
for kc = 1:length(listcomb)
    
icomb = listcomb{kc};
% icomb = [3 4];

nCf = length(icomb); 
methFatures = cell(1,nCf);
for i=1:nCf
methFatures{i} = listDbs{icomb(i)};
end
methFatures = [methFatures{:}];

%load
load([pathNameIn methFatures 'tab.mat']);


[m,n] = size(Datos);
ID = Datos(:,n);
Y = Datos(:,n-1);
id = unique(ID);
O = length(id);
C = length(unique(Y));
M = n-2;


% % CM = zeros(C,C); %Matriz de confusion
RM = zeros(4,M); %micAc, micP, micR, micF1
E = zeros(O,M);

AC = zeros(O,M); 
P  = zeros(O,M); 
R  = zeros(O,M); 
F1 = zeros(O,M);

for k=1:M

%Estimacion
Yest = Datos(:,k);
PER = zeros(C,4); %FN, FP, TP, TN

%Macro
%Analisis de las observaciones
for i=1:O

    %Select object output
    j = (ID==id(i));
    OYest = Yest(j); OY = Y(j);
        
    E(i,k) = mean(double(OYest ~= OY));
    
%     OYest = expandcol(OYest,C)';
%     OY = expandcol(OY,C)';       
    [ ac, p, r, f1 ] = measuresEvaluate( OY, OYest, 'macro' );
    AC(i,k) = ac; P(i,k) = p; R(i,k) = r; F1(i,k) = f1; 

    
    %fprintf('Processing object %d ...\n', i);

end

% % OYest = expandcol(Yest,C);
% % OY = expandcol(Y,C);
% % % plotconfusion(OY',OYest')
% % [c,cm,ind,per] = confusion(OY',OYest');

fprintf('Methods: %s[%s] \n', methFusion{k}, methFatures);
fprintf('ACC: %.2d + %.2d\n', mean(AC(:,k)), std(AC(:,k)));
fprintf('P:   %.2d + %.2d\n', mean(P(:,k)), std(P(:,k)));
fprintf('R:   %.2d + %.2d\n', mean(R(:,k)), std(R(:,k)));
fprintf('F1:  %.2d + %.2d\n', mean(F1(:,k)), std(F1(:,k)));
fprintf('E:   %.2d + %.2d\n', mean(E(:,k)), std(E(:,k)));


%Analisis Micro
% OYest = expandcol(Yest,C)';
% OY = expandcol(Y,C)';
[ micAC, micP, micR, micF1  ] = measuresEvaluate( Y, Yest, 'micro' );
RM(:,k) = [micAC; micP; micR; micF1];

end

%%
%Save result

tablaName = ['texp' methFatures];

%Tablelas com as medidas 
sheet = 1;
tabela = [methFusion; num2cell(AC)];
xlswrite([pathNameOut tablaName '.xlsx'], tabela, sheet);

sheet = 2;
tabela = [methFusion; num2cell(P)];
xlswrite([pathNameOut tablaName '.xlsx'], tabela, sheet);

sheet = 3;
tabela = [methFusion; num2cell(R)];
xlswrite([pathNameOut tablaName '.xlsx'], tabela, sheet);

sheet = 4;
tabela = [methFusion; num2cell(F1)];
xlswrite([pathNameOut tablaName '.xlsx'], tabela, sheet);

sheet = 5;
tabela = [methFusion; num2cell(RM)];
xlswrite([pathNameOut tablaName '.xlsx'], tabela, sheet);

%Tabela resumen 
sheet = 1;
tabela = [methFusion; num2cell(RM)];
xlswrite([pathNameOut 'micro' tablaName '.xlsx'], tabela, sheet);


fprintf('\n\n');


end






