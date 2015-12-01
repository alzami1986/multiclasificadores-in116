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

%print
fprintf('Load data: \n');
fprintf('PathName: %s. \n\n', methods);

%% Data processing


id = unique(ID);
O = length(id);
C = length(unique(Y));
N = length(ID);

Yrp = zeros(N,1);
Yrs = zeros(N,1);
Yrmax = zeros(N,1);
Yrmin = zeros(N,1);
Yrmed = zeros(N,1);
Yrmj = zeros(N,1);




%Esquema de validacion
%Leave one-subject-out (LOSO) cross validation
for kobj = 1:O
    
    
    %% TRAINING
    %Obtener los elementos de validacion
    %Todas las expresiones del actor kobj
    %
    j = (X(:,L + 4) ~= id(kobj));
    Xtrai = X(j,:);  
    
    %Probabilidad a priori
    Ytrai = Xtrai(:,L + 3);
    Ytrai = Ytrai(1:C:end);
    
    %Estimacion de la probabilidad a prior
    Pprior = estimatePrior(Ytrai,C);
    
    
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
                
        %Prob posterior
        Ppost = Xtest( (1:C)+((i-1)*C) , 1:L);  
        
        
        %Ecuation. Josef Kittler [7]
        %Product Rule            
        %P = (Pprior.^(-(L-1))).*prod(Ppost,2);
        %P =  prod(Ppost,2);
        
        P = RP(Ppost);
        [~,k] = max(P);  
        Yrp(iobj(i)) = k;
        
        
        %Ecuation. Josef Kittler [11]
        %Sum Ruler
        %P = (1-L).*Pprior + sum(Ppost,2);
        %P = sum(Ppost,2);
        
        P = RS(Ppost);
        [~,k] = max(P);  
        Yrs(iobj(i)) = k;
        
        
        %Ecuation. Josef Kittler [14][15]
        %Max Ruler
        %P = (1-R).*Pprior + R*max(Ppost,[],2); %[14]
        %P = max(Ppost,[],2); %[15]
        
        P = RMX(Ppost);
        [~,k] = max(P);  
        Yrmax(iobj(i)) = k;
                
               
        %Ecuation. Josef Kittler [16][17]
        %Min Ruler
        %P = (Pprior.^(-(L-1))).*min(Ppost,[],2); %[16]
        %P = min(Ppost,[],2); %[17] 
        
        P = RMI(Ppost);
        [~,k] = max(P);  
        Yrmin(iobj(i)) = k;
        
        
        %Ecuation. Josef Kittler [18]
        %Median Ruler
        %P = (1/L)*sum(Ppost,2); 
        P = RMD(Ppost);
        [~,k] = max(P);  
        Yrmed(iobj(i)) = k;
               
        
        %Ecuation. Josef Kittler [20]
        %Majority Vote Rule
%         dki = zeros(C,L);
%         for j=1:L
%         [~,k] = max(Ppost(:,j));
%         dki(k,j) = 1;
%         end      
%         [~,k] = max( sum(dki,2) );  
        
         P = RMV(Ppost);   
         [~,k] = max( P);
         Yrmj(iobj(i)) = k;
                                     
        
    end    
    
    
    
    
    
end

%%

fprintf('Product Rule:      %.2d + %.2d \n', mean(double(Yrp == Y)), std(double(Yrp == Y)));
fprintf('Sum Rule:          %.2d + %.2d \n', mean(double(Yrs == Y)), std(double(Yrs == Y)));
fprintf('Max Ruler:         %.2d + %.2d \n', mean(double(Yrmax == Y)), std(double(Yrmax == Y)));
fprintf('Min Ruler:         %.2d + %.2d \n', mean(double(Yrmin == Y)), std(double(Yrmin == Y)));
fprintf('Median Ruler:      %.2d + %.2d \n', mean(double(Yrmed == Y)), std(double(Yrmed == Y)));
fprintf('Maj. Vote Rule:    %.2d + %.2d \n', mean(double(Yrmj == Y)), std(double(Yrmj == Y)));





