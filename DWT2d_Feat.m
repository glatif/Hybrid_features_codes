function [feature] = DWT2d_Feat(img)

    [LL1,LH,HL,HH]=dwt2(img,'db2');
    [LL2,LH,HL,HH]=dwt2(LL1,'db2');
    [LL3,LH,HL,HH]=dwt2(LL2,'db2');
    [sw sh]=size(LL3);
    DWT1D=LL3(:);
    
   % Perform PCA on all images
   % [pc,score,latent,tsquare] = princomp(LL3);
   %latent = latent/latent(1,1);
   % pca_img(1:sw*sh,j) = reshape(pc',sw*sh,1);   % Make a column vector
   %Putting top 7 values in vector of eigen values
   %M1 = sqrt(real(latent).^2 + imag(latent).^2);
   
   sortd=sort(DWT1D,'descend');  
   for k=1:25
        feature(k)=sortd(k);
   end  
end