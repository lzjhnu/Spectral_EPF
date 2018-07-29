# Spectral_EPF
%Author: Zhijian Li (Jun, 2018)
%Email:lizhijian@hnu.edu.cn

%--------------------------------------------------------------------------
%   Files introduction
%-------------------------------------------------------------------------
%This package contains a matlab implementation of the Spectral Dimensional Edge-Preserving Filtering Based Feature %Extraction Method.
%
%
%--------------------------------------------------------------------------
%   Files included
%-------------------------------------------------------------------------
%
%  Spectral_EPF.m   -> Spectral_EPF algorithm [1]
%  make_guidence_image.m    -> make_guidence_image for Spectral_EPF
%  filter_in_spectral_parallel.m  -> EPF filter in spectral domain
%  get_traintest.m  -> get the train and test samples
%  SVM.m -> SVM Classifier
%  MLR.m    -> MLR Classifier
%  RF.m    -> RF Classifier
%  Testdata.mat -> Indian Pines Dataset
%
%  DEMOS:
%
%  demo.m             -> Test demo for Indian Pines dataset
%
%--------------------------------------------------------------------------
%    How to run
%-------------------------------------------------------------------------
%
%  Simply download the complete package to a directory and run the demos
%

The code is based on three toolbox.
1) the SVM toolbox which can be downloaded at: http://www.csie.ntu.edu.tw/~cjlin/libsvm/
2) the MLR toolbox which can be downloaded at: http://www.lx.it.pt/~jun/demos.html
3) the RF toolbox which can be downloaded at: https://cran.r-project.org/web/packages/randomForest/index.html

Note: please ensure the toolbox have been correctly installed and included into the working 
