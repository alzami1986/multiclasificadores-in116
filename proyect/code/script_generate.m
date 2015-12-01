%% Processing database output

%% Initialization
clear ; close all; clc
addpath(genpath(pwd));

%% Setting 
%Direccion de los datos
pathName = 'db\';
dir_out = 'out\';

listFilesName = {'ckhoglbp', 'ckhoglbprow', 'ckhoglbprowwg', ...
    'ckhoglbpwg', 'ckhogrow', 'ckhogrowwg', 'ckhogwg', ...
    'cklbprow', 'cklbpwg', 'ckrowwg', 'ckwgrowlbp'};

for mth = 3:11
fileName = listFilesName{mth};


%% Loader data
%PathName create
dir_vectores = [pathName fileName];

%Acceder al file
datos = dir([dir_vectores filesep '*.mat']);
total = size(datos,1);
if isempty(datos)
error('error!!!: dir empty');
end

fprintf('Load data: \n');
fprintf('PathName: %s \nConut: %d \n', dir_vectores, total);


%% Data processing 
  
Ws = [];
numc = 0; %numero de clases
numrep = 0; %numero de representaciones
for i=1:total

    %Cargar los datos
    %alfa_i, y_i, D, clases. 
    try
    load([dir_vectores filesep datos(i).name]);
    catch
    continue;
    end
    
    % Input   
    % alpha_i, vectores alpha obtenido para cada metodo de repres    
    % y_i, señales originales representadas por alpha
    % D, diccionarios  
    % clases, cantidad de objetos por clases
    % actor,  id del actor
    % claseactor clase a la que pertenese
        
    %Calculate error de aproximacion
    %e = ||y-D*soport(alfa_i)||_2
    W = getWeightsOfErrorSpareceVectorDn( D, Yi, alfa_i, clases );
        
    numc = length(clases);
    numrep = size(W,2);
    
    c = 1:numc; obj = i*ones(numc,1); classobj = actorclass*ones(numc,1);
    actorid = actor*ones(numc,1);
    
    % [Ri, C, Obj, CR, Id]
    % Ri representaciones
    % C voto de alfa a la clase c
    % Obj objeto
    % CR clase del objeto
    
    W = [W c' obj classobj actorid];
    Ws = [Ws; W]; 
    
    fprintf('Iter %s ->  %d ...\n', fileName,  i );
    
        
end

% % % %% plot
% % % figure(1);
% % % plot(Ws(:,1),Ws(:,2),'ob');


%% save
save(['out\out' fileName],'Ws','numc','numrep'); 

end

