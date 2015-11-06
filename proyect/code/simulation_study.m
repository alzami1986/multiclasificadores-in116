%%SIMULATION STUDY
% Experiments with simulated classifier outputs were carried out as follows:
% – Number of classes c ? {2, 3, 4, 5, 10, 20, 50};
% – Number of classifiers L ? {2, 3, 4, 5, 10, 20, 50};
% – Number of instances (labels) 500;
% – Number of runs 100.

sim_c = [2, 3, 4, 5, 10, 20, 50]; %Number of classes
sim_l = [2, 3, 4, 5, 10, 20, 50]; %Number of classifiers
sim_num = 49; %numero de combinaciones 49
N = 500; %Number of instances (labels)
R = 100; %Number of runs 100

[paramC,paramL] = meshgrid(sim_c,sim_l);
paramC = paramC(:); 
paramL = paramL(:);

err_mv = zeros(R*49,1); 
err_wmv = zeros(R*49,1); 
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

        [dp,y] = generateOutputs( N,C,L ); 
        
        %MV--
        y_mv = MV( dp ); 
        err_mv(iter) = mean(double(y_mv == y));
        
        %WMV
        y_wmv = WMV( dp, y, C );
        err_wmv(iter) = mean(double(y_wmv == y));
       
        
        %txt
        fprintf('simulation iter %d ...\n',k);
        iter = iter + 1;
        
    end

   
    
end

%% plot
figure; 
plot(err_mv, err_wmv,'.b');



