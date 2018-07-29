function [Gz] = make_guidence_image(image,filter_type, sizexy,sigmaxy)


[r,c,b]=size(image);

if strcmp(filter_type,'average')

    averageFilter=fspecial('average',[sizexy sizexy]); 
    for k=1:1:b
        picz(:,:)=image(:,:,k);
        Gz(:,:,k)=imfilter(picz,averageFilter,'replicate');
    end    
elseif strcmp(filter_type,'gauss')
    gausFilter = fspecial('gaussian',sizexy,sigmaxy);
    for k=1:1:b
        picz(:,:)=image(:,:,k);
        Gz(:,:,k)=imfilter(picz,gausFilter,'replicate');
    end
else
        error(['Unrecognized option: ''' varargin{i} '''']);
end


return