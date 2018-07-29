function [ predicted_labels,out_param ] = MLR(img, train_samples,train_labels,in_param )
%CLASSIFYMLR Classify with libMLR an image
%
%		[ predicted_labels,out_param ] = MLR( train_samples,train_labels,img,in_param )
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
% Parse inputs
if nargin == 4
    algorithm_parameters.lambda=in_param.lambda;
    algorithm_parameters.beta = in_param.beta;
    algorithm_parameters.mu = in_param.mu;   
else
    algorithm_parameters.lambda=0.001;
    algorithm_parameters.beta = 0.5*algorithm_parameters.lambda;
    algorithm_parameters.mu = 4;     
end
    
        train_samples=train_samples';
        train_labels=train_labels';
        img=img';

tic        
        out_param.sigma = 0.8;        
        % build |x_i-x_j| matrix 
        nx = sum(train_samples.^2);
        [X,Y] = meshgrid(nx);
        dist=X+Y-2*train_samples'*train_samples;
        clear X Y
        out_param.scale = mean(dist(:));
        % build design matrix (kernel) 
        K=exp(-dist/2/out_param.scale/out_param.sigma^2);
        clear dist
        % set first line to one 
        K = [ones(1,size(train_samples,2)); K];       

        % learn the regressors
        [w,L] = LORSAL(K,train_labels,algorithm_parameters.lambda,algorithm_parameters.beta);

        learning_output = struct('scale',out_param.scale,'sigma',out_param.sigma);
        % compute the MLR probabilites
        p = mlr_probabilities(img,train_samples,w,learning_output);

        % compute the classification results
        [out_param.maxp, predicted_labels] = max(p);     
        
        %
        out_param.promap=p;

end

