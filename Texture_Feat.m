%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%Feature List%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Histogram Based Features
%1. Mean   2. Varaince 3. Skewness 4. Kurtosis 5. Energy 6. Entropy
%%%%   Second Order Feature based on Co-occurance matrix   %%%%
%%%% 7. Angular second Moment 8.Correlation  9.Inertia 10.Absolte Value
%%%% 11.Inverse Difference 12 .Entropy  13.Maximum Probability
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [feature] = Texture_Feat(img)

feature=[];
[x y z]=size(img);
if z==3
    img=rgb2gray(img);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First order feature extraction
[intensity X]=imhist(img);
g_level=255;

index=1;

for i=1:g_level
    prob(i)=intensity(i)/(x*y);
end

mean_f=0;
var_f=0;
energy=0;
entropy=0;


for i=1:g_level
    prod=i*prob(i);
    mean_f=mean_f+prod;
    energy=energy+square(prob(i));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     x=(i-mean_f)^2;
    prod=x*prob(i);
    var_f=var_f+prod;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    x=log2(prob(i)+.0003);
    prod=x*prob(i);
    entropy=entropy+prod;
    
end

feature(index)=mean_f;          %Feature   Mean
feature(index+1)=var_f;         %Feature   Variance
feature(index+4)=energy;        %Feature

entropy=-entropy;
feature(index+5)=entropy;      %Feature   Entropy







SD=sqrt(var_f);
skw_f=0;
kur_f=0;
for i=1:g_level
    x=(i-mean_f)^3;
    prod=x*prob(i);
    skw_f=skw_f+prod;
    
    x=(i-mean_f)^4;
    prod=x*prob(i);
    kur_f=kur_f+prod;
end

skwness=SD^-3*skw_f;
feature(index+2)=skwness;       %Feature Skewness

kurtsis=SD^-4*kur_f-3;
feature(index+3)=kurtsis;      %Feature  Kurtosis


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Second Order feature extraction%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[r_size c_size]=size(img);
jp=zeros(256,256);



%%theta=0, d=1
for r=1:r_size
    for c=1:c_size
        i=img(r,c)+1;        
        if(c==1)       % first item of row
            j=img(r,c+1)+1;
            jp(i,j)=jp(i,j)+1;
        elseif(c==r_size)   % Last item of row
            j=img(r,c-1)+1;
            jp(i,j)=jp(i,j)+1;
        else 
            j=img(r,c+1)+1;
            jp(i,j)=jp(i,j)+1;
            j=img(r,c-1)+1;
            jp(i,j)=jp(i,j)+1;
        end;
        
    end
end
            
meanx=mean(jp);     %row wise mean
meanx=mean(meanx);
meany=mean(jp,2);   %col wise mean
meany=mean(meany);
stdv=std2(jp);

angular_moment=0; % Homogeneity
inertia=0;          %Contrast
absolute_val=0;
inverse_diff=0;
intensity_entropy=0;
corelate=0;



for i=1:g_level
    for j=1:g_level
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        x=jp(i,j)^2;
        angular_moment=angular_moment+x;        
                
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        x=(i-j)^2;
        prod=x*jp(i,j);        
        inertia=inertia+prod;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        prod=i*j*jp(i,j);
        prod=prod-(meanx*meany);
        prod=prod/(stdv^2);
        corelate=corelate+prod;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        div=jp(i,j)/(1+x);
        inverse_diff=inverse_diff+div;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        x=abs(i-j);
        prod=x*jp(i,j);
        absolute_val=absolute_val+prod;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       if(jp(i,j)~=0)
              x=log2(jp(i,j));
       else
                x=0;
       end
        prod=x*jp(i,j);
        intensity_entropy=intensity_entropy+prod;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end 
     max_prob=max(jp(:));
     feature(index+6)=angular_moment/255;       %Feature  Angular Second Moment
     feature(index+7)=corelate/255;             %Feature  Correlation
     feature(index+8)=inertia/255;              %Feature  Inertia     
     feature(index+9)=absolute_val/255;         %Feature  Absolute Value
     feature(index+10)=inverse_diff/255;        %Feature  Inverse Difference     
     feature(index+11)=intensity_entropy/255;   %Feature  Entropy
     feature(index+12)=max_prob;            %Feature  Maximum Probability
end