%% Multiclasificadores proyecto


%% Initialization
clear ; close all; clc
addpath(genpath(pwd));

pathNameIn = 'out/xls/texp';
pathNameOut = 'out/exp/';

methFusion = {'Yrp','Yrs','Yrmax','Yrmin','Yrmed','Yrmj', 'Ywmv','Yrec','Ynb','Ylop'};
listDbs = {'rowdb', 'wgdb', 'lbpdb', 'hogdb'};
listcomb = geticombine();


%Todas las combinaciones 
for kc = 1:length(listcomb)
    
icomb = listcomb{kc};
nCf = length(icomb); 
methFatures = cell(1,nCf);
for i=1:nCf
methFatures{i} = listDbs{icomb(i)};
end
methFatures = [methFatures{:}];

%read xlsx;
sheet = 1;
[num,txt,raw] = xlsread([pathNameIn methFatures '.xlsx'], sheet);
num = num(:,[1:6 8:11]); %%%%%
[n,m] = size(num);


fprintf('---------------------------------- \n' );
fprintf('Methods: %s \n', methFatures );


%Abanisis descriptivo

mu = mean(num); 
s2 = var(num); 
s = std(num); 
md = median(num);

% % % 
% % % %Test friedman
% % % pf = friedman(num,1,'off');
% % % fprintf('Friedman Test:\nP-valor:%.3f \n', pf );


datos = [mu;s;s2]; 
tabela = [methFusion; num2cell(datos)];
xlswrite([pathNameOut 'acc' methFatures '.xlsx'], tabela);



end



