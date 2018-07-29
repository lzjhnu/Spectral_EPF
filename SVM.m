function [ predicted_labels,output_param ] = SVM(img,train_samples,train_labels,input_param )
%CLASSIFYSVM Classify with libSVM an image
%
%		[ predicted_labels,out_param ] = SVM( train_samples,train_labels,img,in_param )
%
% INPUT
%   train_samples 训练样本
%   train_labels  训练标签
%   img    待分类图像
%   in_param  输入参数
%
% OUTPUT
%   predicted_labels    Classified image
%   out_param  structure reports the values of the parameters
%
% DESCRIPTION
% This routine classify an image according to the training set provided
% with libsvm. By default, the data are scaled and normalized to have unit
% variance and zero mean for each band of the image. If the parameters
% defining the model of the svm (e.g., the cost C and gamma) are not
% provided, the function call the routin MODSEL and which optimizes the
% parameters. Once the model is trained the image is classified and is
% returned as output.

if nargin == 4
    algorithm_parameters.Ccv=in_param.Ccv;
    algorithm_parameters.Gcv = in_param.Gcv;
    algorithm_parameters.cv=in_param.cv;
    algorithm_parameters.cv_t = in_param.cv_t; 
else
    algorithm_parameters.Ccv=10e1;
    algorithm_parameters.Gcv = 2^-3;   
end

    %SVM分类
tic      
        %%%% Select the paramter for SVM with five-fold cross validation
        [algorithm_parameters.Ccv,algorithm_parameters.Gcv,algorithm_parameters.cv,algorithm_parameters.cv_t]=cross_validation_svm(train_labels,train_samples);

        %%%% Training using a Gaussian RBF kernel
        %%% give the parameters of the SVM (Thanks Pedram for providing the
        %%% parameters of the SVM)
        parameter=sprintf('-c %f -g %f -m 500 -t 2 -q',algorithm_parameters.Ccv,algorithm_parameters.Gcv); 
        %%% Train the SVM
        model=svmtrain(train_labels,train_samples,parameter);
        %%%% SVM Classification
        [predicted_labels, out_param.accuracy, out_param.prob_estimates] = svmpredict(ones(length(img),1),img,model); 
        
        
%         parameter=sprintf('-c %f -g %f -m 500 -t 2  -b 1 -q',algorithm_parameters.Ccv,algorithm_parameters.Gcv); 
%         %%% Train the SVM
%         model=svmtrain(train_labels,train_samples,parameter);
%         %%%% SVM Classification
%         [predicted_labels, out_param.accuracy, out_param.prob_estimates] = svmpredict(ones(no_lines*no_rows,1),img,model, '-b 1');        
          %out_param.prob_estimates为某个像素属于某一类的概率
        
return

