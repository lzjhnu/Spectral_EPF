function [fimage] = Spectral_EPF(image,size_w,size_l,sigma_s,sigma_r)
%
% function to get the Spectral_EPF feature from the original image.
%
%  First: get the guidence image Gz 
%  Second:get the feature 
%
%  Input  parameter:    
%                    image    --  original hyspectral image              
%                    size_w   --  the size of the gauss filter for make the spacial guidence image   
%                    size_l   --  spectral EPF filter size 
%                    sigma_s  --  spacial weight of the spectral EPF filter 
%                    sigma_r  --  spectral weight of the spectral EPF filter 
%  Output parameter:
%                    fimage   --  the Spectral_EPF feature
%  
%
%  Copyright: Zhijian Li (lizhijian@hnu.edu.cn)
%
%  For any comments contact the authors

    %make the guidence image Gz
    size_xy=size_w*4;sigmaxy=size_w*2; 
    [Gz] = make_guidence_image(image,'gauss',size_xy,sigmaxy);   %% refer to eqution (10)
    %Get the spectral_EPF feature      
    [fimage] = filter_in_spectral_parallel(image,Gz,size_l,sigma_s,sigma_r);   
    
return
            