%%
clc; clear;
%%

M = 500;
C = 3;
L = 20;
R = 200;

err_mv = zeros(1,R);
err_wmv = zeros(1,R);
err_nb = zeros(1,R);
% s = rng;

for k=1:R    
    
    [dp,y] = generateOutputs( M,C,L );

    
    %MV
    y_mv = MV( dp );
    err_mv(k) = mean(double(y_mv == y)); 
      

	%WMV
    y_wmv = WMV( dp, y, C );
    err_wmv(k) = mean(double(y_wmv == y));
            
    %NB
    y_nb = NB( dp, y, C );
    err_nb(k) = mean(double(y_nb == y));
    
    
    
    fprintf('iter %d ...\n',k);
    
end

%%
% % figure; 
% % plot(err_mv(:), err_wmv(:),'.b');
figure; 
plot(err_mv(:), err_nb(:),'.b');










