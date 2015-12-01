%% Ruler combining
% Read
% [Ri, C, Obj, CR, Id]
% Ri representaciones
% C voto de alfa a la clase c
% Obj objeto
% CR clase del objeto



%% Initialization
clear ; close all; clc
addpath(genpath(pwd));


%% Load data

methodsName = 'lop';
pathNameIn = 'out/prof';
pathNameOut = 'out/ck/';

listDbs = {'rowdb', 'wgdb', 'lbpdb', 'hogdb'};
icomb = [2 3];

L = length(icomb);
methods = cell(1,L);
for i=1:L
methods{i} = listDbs{icomb(i)};
end
methods = [methods{:}];

%load
%X,Y,ID
load([pathNameIn methods '.mat']);


fprintf('Load data: \n');
fprintf('Methods: %s. \n', methods);


%% Processing data

id = unique(ID);
O = length(id);
C = length(unique(Y));
N = length(ID);


Ylop = zeros(N,1);



%Esquema de validacion
%Leave one-subject-out (LOSO) cross validation
for kobj = 1:O
    
    
    %% TRAINING
    %Obtener los elementos de validacion
    %Todas las expresiones del actor kobj
    %
    j = (X(:,L + 4) ~= id(kobj));
    Xval = X(j,:);  
    
    %Para todas las clases
    %crear un modelo
    Theta = zeros(L,C);
    for i = 1:C
    
        
        %seleccionando los alfa_i que votan por la clase i
        j = find(Xval(:,L + 1) == i);        
        jp = find(Xval(j,L + 3) == i);
        jn = find(Xval(j,L + 3) ~= i);
               
        Xjp = Xval(j(jp),1:L); %Xj positivos
        Xjn = Xval(j(jn),1:L); %Xj negativos
        Xtrai = [Xjp; Xjn];
        targe = zeros(length(j),1);
        targe(1:length(jp)) = 1;
               
        theta = LOP(Xtrai,targe);               
        Theta(:,i) = theta;
        
    end
    
    
    
    %% TEST    
    %Obtener los elementos de test
    j = find(X(:,L + 4) == id(kobj));
    Xtest = X(j,:); 
    Ytest = Xtest(:,L + 3);
    Ytest = Ytest(1:C:end);
    
    Nt = size(Xtest,1)/C;
    iobj = Xtest(1:C:end,L + 2);
    
    
    %Para cada objeto de validacion
    for i = 1:Nt
                
        Ppost = Xtest( (1:C)+((i-1)*C) , 1:L);  %prob posterior            
               
        %Predict
        %%Linear Opinion Pools         
        %P(wj) = sum wP  
        %P =  sum((Theta').*Ppost,2);        
        P = predictLOP(Ppost,Theta);
        
        
        [~,k] = max(P);    
        Ylop(iobj(i)) = k;
                       
        
    end    
    
    
    
    
end

%%


fprintf('\nResult: %s \n', methods);
fprintf('LO:  %.2d + %.2d \n', mean(double(Ylop == Y)), std(double(Ylop == Y)));




