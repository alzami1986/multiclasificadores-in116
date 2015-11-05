function [dp,y] = generateOutputs( N,C,L )
%GENERATEOUTPUTS Simulated classifier outputs were carried out
%Intput:
%   N-number of instance
%   C-number of class
%   L-number of classifiers
%
% Example:
%
%   N = 10;
%   C = 3;
%   L = 3;
%   dp = generateOutputs( N,C,L );
%

%% TRUE CLASS LABEL
rp = randperm(N);
si = [1, sort(rp(1:(C-1))), N];
tl = zeros(N,1);
for i=1:C
    tl(si(i):si(i+1)) = i;
end

%%ENSAMBLE CLASS LABEL
el = zeros(N,L);

for j=1:L
    cl=tl;
    pr = (2/3)*rand(C,1);
   
    for i=1:C     
       
        pos = find(cl==i);
        nr = fix(sum(cl==i)*pr(i));
        ca = randi(C,nr,1); 
        cl(pos(1:nr)) = ca;
       
    end
    el(:,j) = cl;    
    
end

%%RETURN
dp = el; %profile desicion
y = tl;  %y etiquetas

end

