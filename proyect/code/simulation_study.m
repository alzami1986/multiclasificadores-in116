%%SIMULATION STUDY
% Experiments with simulated classifier outputs were carried out as follows:
% – Number of classes c \in {2, 3, 4, 5, 10, 20, 50};
% – Number of classifiers L \in {2, 3, 4, 5, 10, 20, 50};
% – Number of instances (labels) 500;
% – Number of runs 100.

%% Initialization
clear ; close all; clc
addpath(genpath(pwd));

sim_c = [2, 3, 4, 5, 10, 20, 50]; %Number of classes
sim_l = [2, 3, 4, 5, 10, 20, 50]; %Number of classifiers
sim_num = 49; %numero de combinaciones 49
N = 500; %Number of instances (labels)
R = 10; %Number of runs 100

[paramC,paramL] = meshgrid(sim_c,sim_l);
paramC = paramC(:); 
paramL = paramL(:);

err_mv = zeros(R*49,1); 
err_wmv = zeros(R*49,1); 
err_rec = zeros(R*49,1);
err_nb = zeros(R*49,1); 

iter=1;

for s=1:sim_num

    
    fprintf('Simulation update...\n');
    fprintf('simulation parameter L=%d C=%d ...\n\n', ...
        paramL(s), paramC(s));
    
    %upadate 
    C = paramC(s);
    L = paramL(s);
    
      
    
    %Run exp
    for k=1:R
        
          
        %% Training 
        %Clasificacion
        %Simula la salida de los clasificadores ...
        [dp, y] = generateOutputs( N, C, L );
        %dp decision profile
        %y  clases
                       
        %Obtener la prob a posteriori de cada clasificador
        %Utiliza la matrix de confucion 
        p = zeros(C,C,L);
        for i = 1:L
        p(:,:,i) = getConfucionMatrix( y, dp(:,i), C );      
        end
        
        %Correxion de las probabilidades 
        %Evita Log(0) y 1/0
        %Si !(1-t < p < t) : p=t          
        t = 1.0e-8;       
        p = (p < t).*t + (p >= t & p <= (1-t)).*p + (p > (1-t)).*(1-t);
    
        
        %Obtener la prob a priori
        prior = zeros(C,1);
        for i=1:C
        prior(i) = sum(dp(:)==i)/(N*L);
        end
    
               
        %% Test
        % Evaluando las reglas de decision
        
        %MV: Majority vote 
        y_mv = MV( dp ); 
        err_mv(iter) = mean(double(y_mv == y));

        
        %WMV: Weighted majority vote
        % P(s_i = ?_k|?_k) = p_i
        post = zeros(L,1);
        for i = 1:L
        post(i) = mean(diag(p(:,:,i)));   
        end       
        
        y_wmv = WMV( dp, C, post, prior );
        err_wmv(iter) = mean(double(y_wmv == y));
               
        
        %REC: Recall combiner
        %P(s_i = ?_k|?_k) = p_{ik}
        post = zeros(C,L);
        for i = 1:L
        post(:,i) = diag(p(:,:,i))';   
        end 
        
        y_rec = REC( dp, C, post, prior  );    
        err_rec(iter) = mean(double(y_rec == y));
                
        %NB: Naive Bayes combiner
        %P(s_i = ?_j|?_k) = p_{ijk}
        post = p;
        y_nb = NB( dp, C, post, prior  );
        err_nb(iter) = mean(double(y_nb == y));
        
        
        %txt
        fprintf('simulation iter %d ...\n',k);
        iter = iter + 1;
        
    end

   
    
end

save('WS_S001');


%% plot


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





