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
icomb = [1 2 3 4];

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

% Yrow = zeros(N,1);
% Ylbp = zeros(N,1);
% Yhog = zeros(N,1);
% Ywg = zeros(N,1);

Arow = zeros(O,1);
Albp = zeros(O,1);
Ahog = zeros(O,1);
Awg = zeros(O,1);


iter = 0;

%Esquema de validacion
%Leave one-subject-out (LOSO) cross validation
for kobj = 1:O
    
    
    %% TRAINING
    %Obtener los elementos de validacion
    %Todas las expresiones del actor kobj
    %
    %j = (X(:,L + 4) ~= id(kobj));
    %Xtrai = X(j,:);  
    
   
    
    %% TEST
    %Obtener los elementos de test
    j = find(X(:,L + 4) == id(kobj));
    Xtest = X(j,:); 
    Ytest = Xtest(:,L + 3);
    Ytest = Ytest(1:C:end);
    
    Nt = size(Xtest,1)/C;     
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
  
%   Yrow((1:nn) + iter) = DP(:,1);
%   Ylbp((1:nn) + iter) = DP(:,2);
% 	Yhog((1:nn) + iter) = DP(:,3);
% 	Ywg((1:nn)  + iter) = DP(:,4);
    
    
    Arow((1:nn) + iter) = mean(double(DP(:,1) == Ytest));
    Albp((1:nn) + iter) = mean(double(DP(:,2) == Ytest));
	Ahog((1:nn) + iter) = mean(double(DP(:,3) == Ytest));
	Awg((1:nn)  + iter) = mean(double(DP(:,4) == Ytest));
    
    
    iter = iter + nn;
    

    
    
end

%%

% fprintf('Row:	%.2d + %.2d \n', mean(double(Yrow == Y)), std(double(Yrow == Y)));
% fprintf('Lbp:	%.2d + %.2d \n', mean(double(Ylbp == Y)), std(double(Ylbp == Y)));
% fprintf('Hog:	%.2d + %.2d \n', mean(double(Yhog == Y)), std(double(Yhog == Y)));
% fprintf('Wg:    %.2d + %.2d \n', mean(double(Ywg == Y)), std(double(Ywg == Y)));
% 

fprintf('Row:	%.2d + %.2d \n', mean(double(Arow)), std(double(Arow)));
fprintf('Lbp:	%.2d + %.2d \n', mean(double(Albp)), std(double(Albp)));
fprintf('Hog:	%.2d + %.2d \n', mean(double(Ahog)), std(double(Ahog)));
fprintf('Wg:     %.2d + %.2d \n', mean(double(Awg)), std(double(Awg)));







