close all
clear all
clc

addpath('.\lib\mlr');
addpath('.\lib\svm_cross_validation');
addpath('.\lib\RF_Class_C');
addpath('.\lib\calc');

%Open the image data
tstart = tic; 
load('./Testdata.mat');  
no_bands=size(img,2);
img  = scale_new(img);  %normalize the image
image=reshape(img,[no_rows,no_columns,no_bands]);
[no_rows,no_columns,no_bands]=size(image);
tim1=toc(tstart);
fprintf('Open Time :   ');disp(tim1);

%load('./train_test.mat');  
%Random select the train samples
perc=15;       %15 samples per class   
[train_set,test_set] = get_traintest(gt,perc);    

%Get the Spectral EPF feature
size_w=13;                          %for Indian Pines
size_l=7; sigma_s=5;sigma_r=0.4;    %for Indian_pines
S_EPF_feature=Spectral_EPF(image,size_w,size_l,sigma_s,sigma_r);
tim2=toc(tstart);
fprintf('SPECTRAL FILTERING Time :   ');disp(tim2-tim1);     

%normalize the feature for classifing
fimg=ToVector(S_EPF_feature);       %convert to vector
fimg=scale_new(fimg);




%get the train samples and the test samples
train_samples = fimg(train_set(:,1),:);
train_labels= train_set(:,2);
test_samples = fimg(test_set(:,1),:);
test_labels = test_set(:,2);   



%SVM classify
tic;   
[svm_cross_results_map] = SVM(fimg, train_samples,train_labels);
classify_time=toc;
fprintf('SVM Classify Time :   ');disp(classify_time);
%%%% Evaluation the performance of the SVM
[svm_cross_results.OA,svm_cross_results.AA,svm_cross_results.kappa,...
svm_cross_results.CA]= confusion(test_labels', svm_cross_results_map(test_set(:,1)));            
fprintf(['SVM OA=',num2str(svm_cross_results.OA),' \r\n']);

%MLR classify
tic;   
[ mlr_results_map ] = MLR(fimg,train_samples,train_labels);
classify_time=toc;
fprintf('MLR Classify Time :   ');disp(classify_time);
%%%% Evaluation the performance of the MLR
[mlr_results.OA,mlr_results.AA,mlr_results.kappa,...
mlr_results.CA]= confusion(test_labels', mlr_results_map(test_set(:,1)));      
fprintf(['MLR OA=',num2str(mlr_results.OA),' \r\n']);

%RF classify
tic;      
model = classRF_train(train_samples,train_labels);
[ rf_results_map ] = classRF_predict(fimg,model);    
classify_time=toc;
fprintf('RF Classify Time :   ');disp(classify_time);
 %%%% Evaluation the performance of the RF
[rf_results.OA,rf_results.AA,rf_results.kappa,...
rf_results.CA]= confusion(test_labels', rf_results_map(test_set(:,1)));      
fprintf(['RF OA=',num2str(rf_results.OA),' \r\n']);


%Print the GroundTruth
gt_image=zeros(no_rows,no_columns);                %
gt_image(gt(:,1))=gt(:,2);                         %

figure('Name', 'Ground Truth');
imagesc(gt_image)

set(gcf,'Position',[150 150 2*no_columns 2*no_rows])
set(gca,'XTick',1:no_columns:no_columns)
set(gca,'XTickLabel',{''})
set(gca,'YTick',1:no_rows:no_rows)
set(gca,'YTickLabel',{''})
title(['Ground Truth']);
colormap(mymap);

%Print the SVM result
map=reshape(svm_cross_results_map,[no_rows,no_columns]);
figure('Name', 'SVM Result');
imagesc(map)

set(gcf,'Position',[150+300 150 2*no_columns 2*no_rows])
set(gca,'XTick',1:no_columns:no_columns)
set(gca,'XTickLabel',{''})
set(gca,'YTick',1:no_rows:no_rows)
set(gca,'YTickLabel',{''})
title(['SVM OA=',num2str(svm_cross_results.OA)]);
colormap(mymap);

%Print the MLR result
figure('Name', 'MLR Result');
map=reshape(mlr_results_map,[no_rows,no_columns]);
imagesc(map)

set(gcf,'Position',[150+600 150 2*no_columns 2*no_rows])
set(gca,'XTick',1:no_columns:no_columns)
set(gca,'XTickLabel',{''})
set(gca,'YTick',1:no_rows:no_rows)
set(gca,'YTickLabel',{''})
title(['MLR OA=',num2str(mlr_results.OA)]);
colormap(mymap);

%Print the RF result
map=reshape(rf_results_map,[no_rows,no_columns]);
figure('Name', 'RF Result');
imagesc(map)

set(gcf,'Position',[150+900 150 2*no_columns 2*no_rows])
set(gca,'XTick',1:no_columns:no_columns)
set(gca,'XTickLabel',{''})
set(gca,'YTick',1:no_rows:no_rows)
set(gca,'YTickLabel',{''})
title(['RF OA=',num2str(rf_results.OA)]);
colormap(mymap);
