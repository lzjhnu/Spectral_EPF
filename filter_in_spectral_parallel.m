function [O] = filter_in_spectral_parallel(image,Gz,size_h,sigmas_z,sigmar_z)

sigmas_z=sigmas_z*0.01;
sigmar_z=sigmar_z*0.01;

[no_rows,no_columns,no_bands]=size(image);

%make the kernel_z
R_z=round(size_h);
%Index_z=[-R_z:1:+R_z];
Index_z=[-R_z:1:+R_z]./sum(abs([-R_z:1:+R_z]));

Gz_extend(:,:,1:R_z)=repmat(Gz(:,:,1),[1,1,R_z]);
Gz_extend(:,:,R_z+1:R_z+no_bands)=Gz(:,:,:);
Gz_extend(:,:,R_z+no_bands+1:2*R_z+no_bands)=repmat(Gz(:,:,no_bands),[1,1,R_z]); 

for i=1:1:2*R_z+1
    gridZ_z(:,:,:,i)=Gz_extend(:,:,i:i+no_bands-1);
    gridZ_z(:,:,:,i)=gridZ_z(:,:,:,i)-Gz;
end
clear Gz_extend 
gridZ_z=reshape(gridZ_z,[no_rows*no_columns*no_bands,2*R_z+1]);

gridX_z=repmat((Index_z),[no_rows*no_columns*no_bands,1]);
% refer to eqution (3),(4),(5)
gridRSquared_z = ( gridX_z .* gridX_z ) / ( sigmas_z * sigmas_z ) + ( gridZ_z .* gridZ_z ) / ( sigmar_z * sigmar_z );
kernel_z = exp( -0.5 * gridRSquared_z );  
clear gridZ_z gridX_z gridRSquared_z;

%Éú³Éimgdata_z
image_extend_z(:,:,1:R_z)=repmat(image(:,:,1),[1,1,R_z]);
image_extend_z(:,:,R_z+1:R_z+no_bands)=image(:,:,:);
image_extend_z(:,:,R_z+no_bands+1:2*R_z+no_bands)=repmat(image(:,:,no_bands),[1,1,R_z]);     
for i=1:1:2*R_z+1
    imgdata_z(:,:,:,i)=image_extend_z(:,:,i:i+no_bands-1);
end
clear image_extend_z;
imgdata_z=reshape(imgdata_z,[no_rows*no_columns*no_bands,2*R_z+1]);

% refer to eqution (7)
K=sum(kernel_z,2);
O=sum(kernel_z.*imgdata_z,2);
%O=O./K;
clear kernel_z imgdata_z;


%reshape output O
O= reshape(O,[no_rows,no_columns,no_bands]);





