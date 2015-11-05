%%
clc; clear;
%%

N = 1000;
C = 3;
L = 3;

num_exp = 100;
err = zeros(1,num_exp);

for k=1:num_exp
    
    [dp,y] = generateOutputs( N,C,L );
    y_pred = MV( dp );
    err(k) = mean(double(y_pred ~= y));
    
    fprintf('iter %d ...\n',k);
    
end

figure; plot(err);