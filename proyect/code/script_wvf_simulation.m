%% Multiclasificadores proyecto
% Paper: A weighted voting framework for classifiers ensembles
% Autor: Ludmila I. Kuncheva · Juan J. Rodríguez
% Springer-Verlag London 2012
% Objetivo:
% SIMULATION STUDY
% Experiments with simulated classifier outputs were carried out as follows:
% – Number of classes c \in {2, 3, 4, 5, 10, 20, 50};
% – Number of classifiers L \in {2, 3, 4, 5, 10, 20, 50};
% – Number of instances (labels) 500;
% – Number of runs 100.

%% Initialization
clear ; close all; clc
addpath(genpath(pwd));

%% Initialization

sim_c = [2, 3, 4, 5, 10, 20, 50]; %Number of classes
sim_l = [2, 3, 4, 5, 10, 20, 50]; %Number of classifiers
Ns = 49; %Numero de combinaciones 49
N = 500; %Number of instances (labels)
R = 100;  %Number of runs 100

% % [paramC,paramL] = meshgrid(sim_c,sim_l);
% % paramC = paramC(:); 
% % paramL = paramL(:);

acc_mv = zeros(7,7,R); 
acc_wmv = zeros(7,7,R); 
acc_rec = zeros(7,7,R);
acc_nb = zeros(7,7,R); 


for s = 1:7
for l = 1:7
        
    
    %upadate 
    %C = paramC(s);
    %L = paramL(s);
    
    C = sim_c(s); %clase
    L = sim_l(l); %num clasificadores
    
    
    fprintf('\nSimulation update...\n');
    fprintf('Simulation parameter L=%d C=%d ...\n\n', ...
        C, L);
    
      
    
    %Run exp
    for k = 1:R
                
         
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
        
        
        %Obtener la prob a priori
        prior = zeros(C,1);
        for i=1:C
        prior(i) = sum(double(y==i))/N; 
        end
        
        %Correxion de las probabilidades 
        %Evita Log(0) y 1/0
        %Si !(1-t < p < t) : p=t          
        t = 1.0e-8;
        p = (p < t).*t + (p >= t & p <= (1-t)).*p + (p > (1-t)).*(1-t);
        prior = (prior < t).*t + (prior >= t & prior <= (1-t)).*prior + (prior > (1-t)).*(1-t);
     
    
               
        %% Test
        % Evaluando las reglas de decision
        
        %MV: Majority vote 
        y_mv = MV( dp ); 
        acc_mv(s,l,k) = mean(double(y_mv == y));

        
        %WMV: Weighted majority vote
        % P(s_i = ?_k|?_k) = p_i
        post = zeros(L,1);
        for i = 1:L
        post(i) = mean(diag(p(:,:,i)));   
        end       
        
        y_wmv = WMV( dp, C, post, prior );
        acc_wmv(s,l,k) = mean(double(y_wmv == y));
               
        
        %REC: Recall combiner
        %P(s_i = ?_k|?_k) = p_{ik}
        post = zeros(C,L);
        for i = 1:L
        post(:,i) = diag(p(:,:,i))';   
        end 
        
        y_rec = REC( dp, C, post, prior  );    
        acc_rec(s,l,k) = mean(double(y_rec == y));
                
        %NB: Naive Bayes combiner
        %P(s_i = ?_j|?_k) = p_{ijk}
        post = p;
        y_nb = NB( dp, C, post, prior  );
        acc_nb(s,l,k) = mean(double(y_nb == y));
        
        
        %txt
        fprintf('simulation iter %d ...\n',k);
        %iter = iter + 1;
        
        
     end
   
    
end
end


save('out/smlt_0002');


%% Graph show
%%
%Fig. 2 Relationship between the ensemble accuracies using the majority 
%vote as the benchmark combiner. Each scatterplot contains 4900 
%ensembles points

n = 5;
xline = (0:n)./n;

%-----
%(a) Weighted Majority Vote

figure1 = figure;
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on');
box(axes1,'on');
hold(axes1,'all');

plot(acc_mv(:), acc_wmv(:),'.k');
hold on
plot(xline,xline,'--k');
hold off

xlabel('Majority Vote');
ylabel('Weighted Majority Vote');
%title('L=100');

axis([0 1 0 1]);
print('graph/MVWMV.eps','-depsc2');

%-----
%(b) Recall

figure2 = figure;
axes2 = axes('Parent',figure2,'YGrid','on','XGrid','on');
box(axes2,'on');
hold(axes2,'all');

plot(acc_mv(:), acc_rec(:),'.r');
hold on
plot(xline,xline,'--k');
hold off

xlabel('Majority Vote');
ylabel('Recall');
%title('L=100');

axis([0 1 0 1]);
print('graph/MVRECALL.eps','-depsc2');

%-----
%(c) Naive Bayes

figure3 = figure;
axes3 = axes('Parent',figure3,'YGrid','on','XGrid','on');
box(axes3,'on');
hold(axes3,'all');

plot(acc_mv(:), acc_nb(:),'.b');
hold on
plot(xline,xline,'--k');
hold off

xlabel('Majority Vote');
ylabel('Naive Bayes');
%title('L=100');

axis([0 1 0 1]);
print('graph/MVNB.eps','-depsc2');


%% 
%Fig. 3 Ensemble accuracies of the 4 combiners as a function of log(c) 
%(exact parameter estimates)


Ac_mv  = mean(acc_mv,3);
Ac_wmv = mean(acc_wmv,3);
Ac_rec = mean(acc_rec,3);
Ac_nb  = mean(acc_nb,3);


idxl = 7; %classifiers 2, 3, 4, 5, 10, 20, 50

figure4 = figure;
axes4 = axes('Parent',figure4,'YGrid','on','XGrid','on');
box(axes4,'on');
hold(axes4,'all');

hold on
plot(log(sim_c),Ac_mv(:,idxl), '-^k', 'DisplayName', 'MV');
plot(log(sim_c),Ac_wmv(:,idxl), '-ob', 'DisplayName', 'WMV');
plot(log(sim_c),Ac_rec(:,idxl), '-sr', 'DisplayName', 'REC');
plot(log(sim_c),Ac_nb(:,idxl), '-dm', 'DisplayName', 'NB');
hold off

% Create legend
legend4 = legend(axes4,'show');
set(legend4,'Location','southeast','Interpreter','latex');

% Create label
xlabel('log(Classes)');
ylabel('Accuracy');

% Create title
title([mat2str(sim_l(idxl)) ' classifiers']);

% axis([0.55 3.999 0 1])



%% 
%Fig. 4 Ensemble accuracies of the 4 combiners as a function of log(L) 
%(exact parameter estimates)

idxc = 2; %classifiers 2, 3, 4, 5, 10, 20, 50

figure5 = figure;
axes5 = axes('Parent',figure5,'YGrid','on','XGrid','on');
box(axes5,'on');
hold(axes5,'all');

hold on
plot(log(sim_l),Ac_mv(idxc,:), '-^k', 'DisplayName', 'MV');
plot(log(sim_l),Ac_wmv(idxc,:), '-ob', 'DisplayName', 'WMV');
plot(log(sim_l),Ac_rec(idxc,:), '-sr', 'DisplayName', 'REC');
plot(log(sim_l),Ac_nb(idxc,:), '-dm', 'DisplayName', 'NB');
hold off

% Create legend
legend5 = legend(axes5,'show');
set(legend5,'Location','southeast','Interpreter','latex');

% Create label
xlabel('log(Classifiers)');
ylabel('Accuracy');

% Create title
title([mat2str(sim_c(idxc)) ' classes']);
% axis([0.55 3.999 inf inf])


