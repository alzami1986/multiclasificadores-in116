function stats = confusionmatStats(confMat)
% OUTPUT
% stats is a structure array
% stats.confusionMat
%               Predicted Classes
%                    p'    n'
%              ___|_____|_____| 
%       Actual  p |     |     |
%      Classes  n |     |     |
%
% stats.accuracy = (TP + TN)/(TP + FP + FN + TN) ; the average accuracy is returned
% stats.precision = TP / (TP + FP)                  % for each class label
% stats.sensitivity = TP / (TP + FN)                % for each class label
% stats.specificity = TN / (FP + TN)                % for each class label
% stats.recall = sensitivity                        % for each class label
% stats.Fscore = 2*TP /(2*TP + FP + FN)            % for each class label
%
% TP: true positive, TN: true negative, 
% FP: false positive, FN: false negative
% 

field1 = 'confusionMat';
% if nargin < 2
%     value1 = group;
% else
%     value1 = confusionmat(group,grouphat);
% end

value1 = confMat;

numOfClasses = size(value1,1);
totalSamples = sum(sum(value1));
    
field2 = 'accuracy';  

[TP,TN,FP,FN,sensitivity,specificity,precision,f_score, accuracy] = deal(zeros(numOfClasses,1));
for class = 1:numOfClasses
   TP(class) = value1(class,class);
   tempMat = value1;
   tempMat(:,class) = []; % remove column
   tempMat(class,:) = []; % remove row
   TN(class) = sum(sum(tempMat));
   FP(class) = sum(value1(:,class))-TP(class);
   FN(class) = sum(value1(class,:))-TP(class);
end

for class = 1:numOfClasses
    sensitivity(class) = TP(class) / (TP(class) + FN(class));
    specificity(class) = TN(class) / (FP(class) + TN(class));
    precision(class) = TP(class) / (TP(class) + FP(class));
    accuracy(class) = (TP(class)+TN(class))/(TP(class)+FP(class)+TN(class)+FN(class));
    f_score(class) = 2*TP(class)/(2*TP(class) + FP(class) + FN(class));
end

macro_fscore = sum(f_score)/numOfClasses;
micro_prec = sum(TP)/(sum(TP)+sum(FP));
micro_recall = sum(TP)/(sum(TP)+sum(FN));
micro_fscore = 2*micro_prec*micro_recall/(micro_recall+micro_prec);

%value2 = (2*trace(value1)+sum(sum(2*value1)))/(numOfClasses*totalSamples);
value2 = (sum(TP)+sum(TN))/(numOfClasses*totalSamples);

field3 = 'recall';  value3 = sensitivity;
field4 = 'specificity';  value4 = specificity;
field5 = 'precision';  value5 = precision;
field7 = 'Fscore';  value7 = f_score;

field8 = 'macroF1'; value8 = macro_fscore;
field9 = 'microF1'; value9 = micro_fscore;
field10 = 'accuracy_class'; value10 = accuracy;

field11 = 'valores'; value11 = [TP TN FP FN];

%new
field12 = 'meanaccuarcy'; value12 = mean(accuracy);
field13 = 'stdaccuracy'; value13 = std(accuracy);


stats = struct(field1,value1,field2,value2,field3,value3,field4,value4,...
    field5,value5,field7,value7,field8, value8, field9, ...
    value9, field10, value10, field11, value11, ...
    field12, value12, field13, value13 );


