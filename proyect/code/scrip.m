%% Multiclasificadores proyecto


%% Initialization
clear ; close all; clc
addpath(genpath(pwd));

%%

N = 500; %No. objects
C = 3;   %No. class
L = 20;  %No. clasificadores   
R = 200; %No. de experimentos

err_mv = zeros(1,R);
err_wmv = zeros(1,R);
err_rec = zeros(1,R);
err_nb = zeros(1,R);
s = rng;

for kf = 1:R    
    
    
    %Clasificacion
    %Simula la salida de los clasificadores ...
    [dp, y] = generateOutputs( N, C, L );
    %dp desicion profile
    %y  clases
    
    %Training    
    %prob de cada clasificador
    p = zeros(C,C,L);
    for i = 1:L
    p(:,:,i) = getConfucionMatrix( y, dp(:,i), C );      
    end
        
    t = 1.0e-8;
    p = (p < t).*t + (p >= t & p <= (1-t)).*p + (p > (1-t)).*(1-t);
    
        
    %prob a priori
    prior = zeros(C,1);
    for i=1:C
    prior(i) = sum(dp(:)==i)/(N*L);
    end
    
           
    %Test
    %Aplicando relgas de fusion  
    
    %MV    
    y_mv = MV( dp );
    err_mv(kf) = mean(double(y_mv == y));   
    
	%WMV
    post = zeros(L,1);
    for i = 1:L
    post(i) = mean(diag(p(:,:,i)));   
    end       
    y_wmv = WMV( dp, C, post, prior );
    err_wmv(kf) = mean(double(y_wmv == y));

            
    %RECALL
    post = zeros(C,L);
    for i = 1:L
    post(:,i) = diag(p(:,:,i))';   
    end 
    y_rec = REC( dp, C, post, prior  );
    err_rec(kf) = mean(double(y_rec == y));
        
    
    %NB
    post = p;
    y_nb = NB( dp, C, post, prior );
    err_nb(kf) = mean(double(y_nb == y));
    
    
    
    fprintf('iter %d ...\n',kf);
    
end

%% Plot

n = 5;
xline = (1:n)./n;

figure; 
plot(err_mv(:), err_wmv(:),'.k');
hold on
plot(xline,xline,'--k');
hold off

xlabel('Majority Vote');
ylabel('Weighted Majority Vote');
title('L=100');

%-----

figure; 
plot(err_mv(:), err_rec(:),'.r');
hold on
plot(xline,xline,'--k');
hold off

xlabel('Majority Vote');
ylabel('Recall');
title('L=100');

%-----

figure; 
plot(err_mv(:), err_nb(:),'.b');
hold on
plot(xline,xline,'--k');
hold off

xlabel('Majority Vote');
ylabel('Naive Bayes');
title('L=100');







