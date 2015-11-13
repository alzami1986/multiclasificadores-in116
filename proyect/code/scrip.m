%%
clc; clear;
%%

M = 500;
C = 3;
L = 20;
R = 200;

err_mv = zeros(1,R);
err_wmv = zeros(1,R);
err_rec = zeros(1,R);
err_nb = zeros(1,R);
% s = rng;

for k=1:R    
    
    %Simula la salida de los clasificadores ...
    [dp,y] = generateOutputs( M,C,L );

    %Aplicando relgas de fusion  
    
    %MV
    y_mv = MV( dp );
    err_mv(k) = mean(double(y_mv == y));       

	%WMV
    y_wmv = WMV( dp, y, C );
    err_wmv(k) = mean(double(y_wmv == y));
            
    %RECALL
    y_rec = REC( dp, y, C );
    err_rec(k) = mean(double(y_rec == y));
    
    %NB
    y_nb = NB( dp, y, C );
    err_nb(k) = mean(double(y_nb == y));
    
    
    
    fprintf('iter %d ...\n',k);
    
end

%% Plot

n = 5;
xline = (1:n)./n;

figure; 
plot(err_mv(:), err_wmv(:),'.b');
hold on
plot(xline,xline,'--k');
hold off

xlabel('Majority Vote');
ylabel('Weighted Majority Vote');
title('L=100');

figure; 
plot(err_mv(:), err_rec(:),'.b');
hold on
plot(xline,xline,'--k');
hold off

xlabel('Majority Vote');
ylabel('Weighted Majority Vote');
title('L=100');



% % figure; 
% % plot(err_mv(:), err_nb(:),'.b');
% % hold on
% % plot(xline,xline,'--k');
% % hold off
% % 
% % xlabel('Majority Vote');
% % ylabel('Naive Bayes');
% % title('L=100');







