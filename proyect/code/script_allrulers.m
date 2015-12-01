%% Multiclasificadores proyecto
% Objetivo: Ruler combining
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
pathNameOut = 'out/tablas/';

listDbs = {'rowdb', 'wgdb', 'lbpdb', 'hogdb'};
listcomb = geticombine();


%Todas las combinaciones 
for kc = 1:length(listcomb)
icomb = listcomb{kc};
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
fprintf('PathName: %s. \n', methods);

%% Data processing


id = unique(ID);
O = length(id);
C = length(unique(Y));
N = length(ID);


%Ruler soft
Yrp = zeros(N,1);
Yrs = zeros(N,1);
Yrmax = zeros(N,1);
Yrmin = zeros(N,1);
Yrmed = zeros(N,1);
Yrmj = zeros(N,1);

%Ruler hard
Ymv = zeros(N,1);
Ywmv = zeros(N,1);
Yrec = zeros(N,1);
Ynb = zeros(N,1);

%Linal pool
Ylop = zeros(N,1);


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
    Nt = size(Xtrai,1)/C;
    idx = 1:C;
    DP = zeros(Nt,L); 
    for ii=1:Nt       
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
    
    
    %Linal pool   
    
    %Para todas las clases
    %crear un modelo
    Theta = zeros(L,C);
    for i = 1:C
            
        %seleccionando los alfa_i que votan por la clase i
        j = find(Xtrai(:,L + 1) == i);        
        jp = find(Xtrai(j,L + 3) == i);
        jn = find(Xtrai(j,L + 3) ~= i);
               
        Xjp = Xtrai(j(jp),1:L); %Xj positivos
        Xjn = Xtrai(j(jn),1:L); %Xj negativos
        x = [Xjp; Xjn];
        targe = zeros(length(j),1);
        targe(1:length(jp)) = 1;
               
        %Estandarizando
        mu = mean(x);
        x = bsxfun(@minus, x, mu);
        sigma = std(x);
        x = bsxfun(@rdivide, x, sigma); 
        
        %Error P(w_j|x) - d_{i,j}(x)
        x = bsxfun(@minus, targe, x);
        
        %Ecuacion Kuncheva [5.29]  
        % funcion de costo: J = sum sum w_iw_k Sigma_ik - landa(sum (w_i - 1) )
        % min_w J(x)    
          
        I = ones(L,1);
        Sigma = cov(x);
        %Sigma = (1/(size(X12,1)-1))*(X12')*X12;  
        
        iSigma = pinv(Sigma);                     
        w = iSigma*I*pinv(I'*iSigma*I);
               
        Theta(:,i) = w;
        
    end
    
    
    
    
    
    %% TEST
    %Obtener los elementos de test
    j = find(X(:,L + 4) == id(kobj));
    Xtest = X(j,:); 
    Ytest = Xtest(:,L + 3);
    Ytest = Ytest(1:C:end);
    
    Nt = size(Xtest,1)/C;     
    iobj = Xtest(1:C:end,L + 2);
    
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    
    %Hard
    %Predict
    idx = 1:C;
    DP = zeros(Nt,L);        
    for ii=1:Nt        
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
    
    
    
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %Soft
    %Para cada objeto de validacion
    for i = 1:Nt
                
        %Prob posterior
        Ppost = Xtest( (1:C)+((i-1)*C) , 1:L); 
        
        %Ecuation. Josef Kittler [7]
        %Product Rule            
        %P = (prior.^(-(L-1))).*prod(Ppost,2);     
        P = prod(Ppost,2);
        [~,k] = max(P);  
        Yrp(iobj(i)) = k;
        
        
        %Ecuation. Josef Kittler [11]
        %Sum Ruler
        P = (1-L).*prior + sum(Ppost,2);
        %P = sum(Ppost,2);
        [~,k] = max(P);  
        Yrs(iobj(i)) = k;
        
        
        %Ecuation. Josef Kittler [14][15]
        %Max Ruler
        %P = (1-R).*prior + R*max(Ppost,[],2); %[14]
        P = max(Ppost,[],2); %[15]
        [~,k] = max(P);  
        Yrmax(iobj(i)) = k;
                
       
        %Ecuation. Josef Kittler [16][17]
        %Min Ruler
        %P = (prior.^(-(L-1))).*min(Ppost,[],2); %[16]
        P = min(Ppost,[],2); %[17] 
        [~,k] = max(P);  
        Yrmin(iobj(i)) = k;
        
        
        %Ecuation. Josef Kittler [18]
        %Median Ruler
        P = (1/L)*sum(Ppost,2); 
        [~,k] = max(P);  
        Yrmed(iobj(i)) = k;
               
        
        %Ecuation. Josef Kittler [20]
        %Majority Vote Rule
        dki = zeros(C,L);
        for j=1:L
        [~,k] = max(Ppost(:,j));
        dki(k,j) = 1;
        end      
        [~,k] = max( sum(dki,2) );  
        Yrmj(iobj(i)) = k;
        
        
        %Predict
        %%Linear Opinion Pools         
        %P(wj) = sum wP  
        P =  sum((Theta').*Ppost,2);        
        [~,k] = max(P);    
        Ylop(iobj(i)) = k;
                                     
        
    end    
    
    
end

%%

fprintf('Result: \n' );
fprintf('Soft fustion: -----------------\n');
fprintf('Product Rule:      %.2d + %.2d \n', mean(double(Yrp == Y)), std(double(Yrp == Y)));
fprintf('Sum Rule:          %.2d + %.2d \n', mean(double(Yrs == Y)), std(double(Yrs == Y)));
fprintf('Max Ruler:         %.2d + %.2d \n', mean(double(Yrmax == Y)), std(double(Yrmax == Y)));
fprintf('Min Ruler:         %.2d + %.2d \n', mean(double(Yrmin == Y)), std(double(Yrmin == Y)));
fprintf('Median Ruler:      %.2d + %.2d \n', mean(double(Yrmed == Y)), std(double(Yrmed == Y)));
fprintf('Maj. Vote Rule:    %.2d + %.2d \n', mean(double(Yrmj == Y)), std(double(Yrmj == Y)));
fprintf('Hard fustion: -----------------\n');
fprintf('MV:                %.2d + %.2d \n', mean(double(Ymv == Y)), std(double(Ymv == Y)));
fprintf('WMV:               %.2d + %.2d \n', mean(double(Ywmv == Y)), std(double(Ywmv == Y)));
fprintf('REC:               %.2d + %.2d \n', mean(double(Yrec == Y)), std(double(Yrec == Y)));
fprintf('NB:                %.2d + %.2d \n', mean(double(Ynb == Y)), std(double(Ynb == Y)));
fprintf('Lineal opinion pool: -----------------\n');
fprintf('LOP:               %.2d + %.2d \n', mean(double(Ylop == Y)), std(double(Ylop == Y)));
fprintf('\n');

% % %Save result
% % Datos = [Yrp,Yrs,Yrmax,Yrmin,Yrmed,Yrmj,Ymv,Ywmv,Yrec,Ynb,Ylop,Y,ID ]; 
% % save([pathNameOut methods 'tab.mat'], 'Datos');
% % % clear R;



end

