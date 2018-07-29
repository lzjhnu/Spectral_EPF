function [train_set,test_set] = get_traintest(gt,perc)

    %total data and total class
    trainall = gt; 
    no_class = max(gt(:,2));
    %remove the unknown samples
    trainall(find(trainall(:,2)==0),:)=[];
    %total samples
    total_number=length(trainall);
    %radom select teh train samples
    %indexes             = train_test_random_equal_percent(trainall(:,2)',perc,total_number*perc);
    indexes             = train_test_random_equal_number(trainall(:,2)',perc,no_class*perc);   %perc numbers per class


    %get the train set
    train_set           = trainall(indexes,:);
    
    %test set =totalset-train set
    test_set            = trainall;
    test_set(indexes,:) =[];    




return

% %-----------------------------------------------------------------------%    
    
    