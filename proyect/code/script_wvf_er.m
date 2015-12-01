%% Multiclasificadores proyecto
%  Objetivo: Clasificar


%% Initialization
clear ; close all; clc
addpath(genpath(pwd));


%% Load data

methodsName = 'wvf';
pathNameIn = 'out/prof';
pathNameOut = 'out/ck/result';

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
fprintf('Loader data\nName: %s\n', methods );


%% Data processing

id = unique(ID);
O = length(id);
C = length(unique(Y));
N = length(ID);

Ymv = zeros(N,1);
Ywmv = zeros(N,1);
Yrec = zeros(N,1);
Ynb = zeros(N,1);


%Esquema de validacion
%Leave one-subject-out (LOSO) cross validation
for kobj = 1:O
    
    
    %% TRAINING
    %Obtener los elementos de validacion
    %Todas las expresiones del actor kobj
    %
    j = (X(:,L + 4) ~= id(kobj));
    Xtrai = X(j,:);  
    Ytrai = Xtrai(:,L + 3);
    Ytrai = Ytrai(1:C:end);       
   
    %Predict
    nn = size(Xtrai,1)/C;
    idx = 1:C;
    DP = zeros(nn,L); 
    for ii=1:nn       
        x = Xtrai(idx,1:L); 
        [~,k] = max(x);  
        DP(ii,:) = k;
        idx = idx + C;
    end
   
   
    %Probabilidad a priori    
    prior = zeros(C,1);
    for i=1:C
    prior(i) = sum(double(Ytrai==i))/length(Ytrai);
    %prior(i) = 1/C;
    end        
    
   %prob de cada clasificador
    p = zeros(C,C,L);
    for i = 1:L
    p(:,:,i) = getConfucionMatrix( Ytrai, DP(:,i), C );
    end

    t = 1.0e-8;
    p = (p < t).*t + (p >= t & p <= (1-t)).*p + (p > (1-t)).*(1-t);
    
        
    %% TEST
    %Obtener los elementos de test
    j = find(X(:,L + 4) == id(kobj));    
    Xtest = X(j,:); 
    Ytest = Xtest(:,L + 3);
    Ytest = Ytest(1:C:end);    
    iobj = Xtest(1:C:end,L + 2);
    
    nn = size(Xtest,1)/C;
    idx = 1:C;
    DP = zeros(nn,L);        
    for ii=1:nn        
        x = Xtest(idx,1:L); %Wj obj i
        [~,k] = max(x);  
        DP(ii,:) = k;
        idx = idx + C;
    end
    
    %MV    
    y_mv = MV( DP );
    Ymv(iobj) = y_mv;  

    %WMV
    post = zeros(L,1);
    for i = 1:L
    post(i) = mean(diag(p(:,:,i)));   
    end       
    y_wmv = WMV( DP, C, post, prior );
    Ywmv(iobj) = y_wmv; 
        
    %RECALL
    post = zeros(C,L);
    for i = 1:L
    post(:,i) = diag(p(:,:,i))';   
    end 
    y_rec = REC( DP, C, post, prior  );
    Yrec(iobj) = y_rec;
        
    %NB
    post = p;
    y_nb = NB( DP, C, post, prior );
    Ynb(iobj) = y_nb;
    
      
    
    
    
end

%%

fprintf('\nResult: \n');
fprintf('MV:    %.2d + %.2d \n', mean(double(Ymv == Y)), std(double(Ymv == Y)));
fprintf('WMV:   %.2d + %.2d \n', mean(double(Ywmv == Y)), std(double(Ywmv == Y)));
fprintf('REC:   %.2d + %.2d \n', mean(double(Yrec == Y)), std(double(Yrec == Y)));
fprintf('NB:    %.2d + %.2d \n', mean(double(Ynb == Y)), std(double(Ynb == Y)));




